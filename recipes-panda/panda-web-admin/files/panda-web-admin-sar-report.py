#!/usr/bin/env python3
"""
Generate a merged HTML report of CPU and memory usage from all available sysstat
data files.

Reads every daily data file in the sysstat log directory (default
/var/log/sysstat, falling back to /var/log/sa), runs `sadf -j` per file for
timestamped CPU (-u) and memory (-r) stats, captures LINUX RESTART markers from
`sar` text output, merges everything into one date-ordered timeline (newest
first), and writes an embeddable HTML fragment (a self-contained <div>, with no
<html>/<head>/<body> wrapper) to standard output. All styles are scoped under
.sar-report so they won't affect the surrounding page.

Embed the output directly inside any element of a host page.
"""

import argparse
import glob
import json
import os
import re
import shutil
import subprocess
import sys
from datetime import datetime, timezone
from html import escape


# Standard locations for saved sysstat data files, in priority order.
SA_DIRS = ["/var/log/sysstat", "/var/log/sa"]
# Daily files are named saNN (day of month) or saYYYYMMDD; skip reports (sarNN).
SA_GLOB = "sa[0-9]*"


def find_sa_files(log_dir=None):
    """Return a sorted list of sysstat data files (saNN / saYYYYMMDD)."""
    dirs = [log_dir] if log_dir else SA_DIRS
    files = []
    for d in dirs:
        if d and os.path.isdir(d):
            for p in glob.glob(os.path.join(d, SA_GLOB)):
                base = os.path.basename(p)
                # Exclude report files (sarNN) and activity files we can't read.
                if base.startswith("sar"):
                    continue
                if os.path.isfile(p):
                    files.append(p)
            if files:
                break  # first directory that yields files wins
    return sorted(set(files))


def run_sadf(sa_file):
    """Run sadf in JSON mode on one data file, returning parsed JSON or None."""
    # -j = JSON output; everything after '--' is passed to sar.
    # -u ALL = full CPU stats, -r = memory utilization.
    cmd = ["sadf", "-j", sa_file, "--", "-u", "ALL", "-r"]
    try:
        out = subprocess.run(
            cmd, capture_output=True, text=True, check=True
        ).stdout
    except subprocess.CalledProcessError as e:
        sys.stderr.write(f"warning: sadf failed on {sa_file}: "
                         f"{e.stderr.strip() or e}\n")
        return None
    try:
        return json.loads(out)
    except json.JSONDecodeError:
        sys.stderr.write(f"warning: could not parse sadf JSON for {sa_file}\n")
        return None


def get_restarts(sa_file):
    """Return (date, time) tuples where 'LINUX RESTART' appears in sar output.

    sadf JSON omits restart markers, so we parse plain `sar -u` text. The header
    line carries the file's date; each restart line carries only a time, so we
    pair each restart with the most recently seen date.
    """
    if shutil.which("sar") is None:
        return []

    env = dict(os.environ, S_TIME_FORMAT="ISO", LC_ALL="C")
    try:
        out = subprocess.run(
            ["sar", "-u", "-f", sa_file],
            capture_output=True, text=True, check=True, env=env,
        ).stdout
    except subprocess.CalledProcessError:
        return []

    restarts = []
    cur_date = ""
    date_re = re.compile(r"\b(\d{4}-\d{2}-\d{2})\b")
    for line in out.splitlines():
        d = date_re.search(line)
        if d:
            cur_date = d.group(1)
        if "LINUX RESTART" not in line:
            continue
        m = re.match(r"\s*(\S+)\s+LINUX RESTART", line)
        if m:
            restarts.append((cur_date, m.group(1)))
    return restarts


def extract_rows(data, rows, meta):
    """Flatten one file's sadf JSON into the shared rows dict (keyed by datetime).

    rows: dict mapping 'YYYY-MM-DD HH:MM:SS' -> record. Shared across files so
    overlapping or sequential days merge into a single timeline.
    meta: dict filled in from the first host seen.
    """
    hosts = data.get("sysstat", {}).get("hosts", [])
    if not hosts:
        return

    host = hosts[0]
    if not meta:
        meta.update({
            "nodename": host.get("nodename", "unknown"),
            "machine": host.get("machine", ""),
            "sysname": host.get("sysname", ""),
            "release": host.get("release", ""),
            "cpus": host.get("number-of-cpus", ""),
        })

    for stat in host.get("statistics", []):
        ts = stat.get("timestamp", {})
        date = ts.get("date", "")
        time = ts.get("time", "")
        key = f"{date} {time}".strip()

        rec = rows.setdefault(key, {"time": key, "sort": key})

        # CPU: 'cpu-load-all' (with -u ALL) or 'cpu-load'. Grab the 'all' cpu.
        cpu_block = stat.get("cpu-load-all") or stat.get("cpu-load") or []
        for c in cpu_block:
            if str(c.get("cpu")) == "all":
                idle = c.get("idle", 0.0)
                rec["cpu_used"] = round(100.0 - idle, 2)
                rec["cpu_user"] = c.get("usr", c.get("user", 0.0))
                rec["cpu_sys"] = c.get("sys", c.get("system", 0.0))
                rec["cpu_iowait"] = c.get("iowait", 0.0)
                break

        # Memory: 'memory' block.
        mem = stat.get("memory")
        if mem:
            rec["mem_used_pct"] = mem.get("memused-percent", mem.get("memused", None))
            used_kb = mem.get("memused")
            free_kb = mem.get("memfree")
            if used_kb is not None:
                rec["mem_used_mb"] = round(used_kb / 1024, 1)
            if free_kb is not None:
                rec["mem_free_mb"] = round(free_kb / 1024, 1)


def build_timeline(rows, restarts):
    """Combine data rows and restart markers into one list, newest first.

    rows: dict keyed by 'YYYY-MM-DD HH:MM:SS'.
    restarts: list of (date, time) tuples. Missing dates sort by time alone,
    placed after dated rows sharing that time.
    """
    marker_rows = []
    for date, time in restarts:
        label = f"{date} {time}".strip()
        sort = f"{date} {time}" if date else f"~ {time}"  # '~' sorts after digits
        marker_rows.append({"time": label, "restart": True, "sort": sort})

    combined = sorted(
        list(rows.values()) + marker_rows, key=lambda r: r["sort"], reverse=True
    )
    for r in combined:
        r.pop("sort", None)
    return combined


def bar(pct):
    """Return an inline mini-bar cell for a percentage (0-100)."""
    if pct is None:
        return '<span class="sar-na">—</span>'
    pct = max(0.0, min(100.0, float(pct)))
    hue = "hot" if pct >= 80 else "warm" if pct >= 50 else "cool"
    return (
        f'<span class="sar-val">{pct:.1f}%</span>'
        f'<span class="sar-track"><span class="sar-fill {hue}" '
        f'style="width:{pct:.1f}%"></span></span>'
    )


def render_html(rows, meta, stats):
    generated = datetime.now(timezone.utc).astimezone().strftime("%Y-%m-%d %H:%M:%S %Z")
    host_line = " · ".join(
        p for p in [
            escape(meta.get("nodename", "")),
            escape(meta.get("sysname", "")),
            escape(meta.get("release", "")),
            (f'{escape(str(meta.get("cpus")))} CPUs' if meta.get("cpus") else ""),
        ] if p
    )

    span = ""
    if stats.get("first") and stats.get("last"):
        span = f'{escape(stats["first"])} → {escape(stats["last"])}'
    sub_bits = [b for b in [
        span,
        (f'{stats["files"]} data file{"s" if stats["files"] != 1 else ""}'
         if stats.get("files") else ""),
        (f'{stats["restarts"]} restart{"s" if stats["restarts"] != 1 else ""}'
         if stats.get("restarts") else ""),
    ] if b]
    sub_line = " · ".join(sub_bits)

    body_rows = []
    for r in rows:
        if r.get("restart"):
            body_rows.append(
                '<tr class="sar-restart">'
                f'<td class="sar-ts">{escape(r.get("time", ""))}</td>'
                '<td colspan="7"><span class="sar-badge">LINUX RESTART</span> '
                'system reboot detected</td>'
                "</tr>"
            )
            continue
        body_rows.append(
            "<tr>"
            f'<td class="sar-ts">{escape(r.get("time", ""))}</td>'
            f'<td class="sar-bar">{bar(r.get("cpu_used"))}</td>'
            f'<td class="sar-num">{r.get("cpu_user", "—")}</td>'
            f'<td class="sar-num">{r.get("cpu_sys", "—")}</td>'
            f'<td class="sar-num">{r.get("cpu_iowait", "—")}</td>'
            f'<td class="sar-bar">{bar(r.get("mem_used_pct"))}</td>'
            f'<td class="sar-num">{r.get("mem_used_mb", "—")}</td>'
            f'<td class="sar-num">{r.get("mem_free_mb", "—")}</td>'
            "</tr>"
        )
    tbody = "\n".join(body_rows) or (
        '<tr><td colspan="8" class="sar-empty">No data returned by sadf.</td></tr>'
    )

    return f"""<div class="sar-report">
<style>
  .sar-report {{
    --sar-ink: #ffffff; --sar-muted: #a8adb5; --sar-line: #4a4a4a;
    --sar-bg: #303030; --sar-panel: #383838;
    --sar-cool: #4a9de0; --sar-warm: #e0a341; --sar-hot: #e85d6f;
    --sar-mono: ui-monospace, "SF Mono", "Cascadia Code", Menlo, monospace;
    box-sizing: border-box;
    background: var(--sar-bg); color: var(--sar-ink);
    font: 15px/1.5 system-ui, -apple-system, Segoe UI, Roboto, sans-serif;
    padding: 32px 24px; border-radius: 12px;
  }}
  .sar-report *, .sar-report *::before, .sar-report *::after {{
    box-sizing: border-box;
  }}
  .sar-report .sar-wrap {{ max-width: 1000px; margin: 0 auto; }}
  .sar-report .sar-header {{ margin-bottom: 24px; }}
  .sar-report h1 {{
    font-size: 24px; margin: 0 0 4px; letter-spacing: -0.02em;
    font-weight: 650; color: var(--sar-ink);
  }}
  .sar-report .sar-meta {{
    color: var(--sar-muted); font-size: 13px; font-family: var(--sar-mono);
  }}
  .sar-report .sar-sub {{
    color: var(--sar-muted); font-size: 12px; margin-top: 6px;
  }}
  .sar-report .sar-panel {{
    background: var(--sar-panel); border: 1px solid var(--sar-line);
    border-radius: 10px; overflow: hidden;
  }}
  .sar-report table {{ width: 100%; border-collapse: collapse; }}
  .sar-report thead th {{
    text-align: left; font-size: 11px; text-transform: uppercase;
    letter-spacing: 0.06em; color: var(--sar-muted); font-weight: 600;
    padding: 12px 14px; border-bottom: 1px solid var(--sar-line);
    white-space: nowrap; background: #333333;
  }}
  .sar-report tbody td {{
    padding: 10px 14px; border-bottom: 1px solid var(--sar-line);
    font-size: 13px; vertical-align: middle; color: var(--sar-ink);
  }}
  .sar-report tbody tr:last-child td {{ border-bottom: none; }}
  .sar-report tbody tr:hover {{ background: #414141; }}
  .sar-report .sar-ts {{
    font-family: var(--sar-mono); color: var(--sar-muted); white-space: nowrap;
  }}
  .sar-report .sar-num {{ font-family: var(--sar-mono); text-align: right; }}
  .sar-report .sar-bar {{ min-width: 150px; }}
  .sar-report .sar-val {{
    font-family: var(--sar-mono); font-size: 12px;
    display: inline-block; width: 46px;
  }}
  .sar-report .sar-track {{
    display: inline-block; width: calc(100% - 54px); height: 7px;
    background: var(--sar-line); border-radius: 4px; overflow: hidden;
    vertical-align: middle;
  }}
  .sar-report .sar-fill {{ display: block; height: 100%; border-radius: 4px; }}
  .sar-report .sar-fill.cool {{ background: var(--sar-cool); }}
  .sar-report .sar-fill.warm {{ background: var(--sar-warm); }}
  .sar-report .sar-fill.hot  {{ background: var(--sar-hot); }}
  .sar-report .sar-na, .sar-report .sar-empty {{ color: var(--sar-muted); }}
  .sar-report .sar-empty {{ text-align: center; padding: 30px; }}
  .sar-report tr.sar-restart td {{
    background: #4a2f33; color: var(--sar-hot); font-size: 12px;
  }}
  .sar-report tr.sar-restart:hover td {{ background: #56363b; }}
  .sar-report tr.sar-restart .sar-ts {{ color: var(--sar-hot); }}
  .sar-report .sar-badge {{
    display: inline-block; font-family: var(--sar-mono); font-size: 11px;
    font-weight: 600; letter-spacing: 0.04em; color: #fff;
    background: var(--sar-hot); padding: 1px 7px; border-radius: 4px;
    margin-right: 8px;
  }}
  .sar-report .sar-grp {{ border-left: 1px solid var(--sar-line); }}
  .sar-report .sar-footer {{
    margin-top: 16px; color: var(--sar-muted); font-size: 12px;
  }}
</style>
  <div class="sar-wrap">
    <div class="sar-panel">
      <table>
        <thead>
          <tr>
            <th rowspan="2">Timestamp</th>
            <th colspan="4">CPU</th>
            <th colspan="3" class="sar-grp">Memory</th>
          </tr>
          <tr>
            <th>Used</th><th>%user</th><th>%sys</th><th>%iowait</th>
            <th class="sar-grp">Used</th><th>Used (MB)</th><th>Free (MB)</th>
          </tr>
        </thead>
        <tbody>
{tbody}
        </tbody>
      </table>
    </div>
    <div class="sar-footer">Generated {escape(generated)} · source: sadf (sysstat)</div>
  </div>
</div>
"""


def main():
    ap = argparse.ArgumentParser(
        description="Merged HTML CPU/memory report from all sysstat data files."
    )
    ap.add_argument("-d", "--dir",
                    help="sysstat log directory (default: /var/log/sysstat, "
                         "then /var/log/sa)")
    args = ap.parse_args()

    if shutil.which("sadf") is None:
        sys.exit("Error: 'sadf' not found. Install the 'sysstat' package.")

    sa_files = find_sa_files(args.dir)
    if not sa_files:
        where = args.dir or " or ".join(SA_DIRS)
        sys.exit(f"No sysstat data files found in {where}.")

    rows = {}
    meta = {}
    restarts = []
    used = 0
    for f in sa_files:
        data = run_sadf(f)
        if data is None:
            continue
        extract_rows(data, rows, meta)
        restarts.extend(get_restarts(f))
        used += 1

    timeline = build_timeline(rows, restarts)

    data_keys = sorted(rows)
    stats = {
        "files": used,
        "restarts": len(restarts),
        "first": data_keys[0] if data_keys else "",
        "last": data_keys[-1] if data_keys else "",
    }

    sys.stdout.write(render_html(timeline, meta, stats))


if __name__ == "__main__":
    main()
