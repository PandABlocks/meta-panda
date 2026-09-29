#!/usr/bin/env python
import argparse
import os
import requests
import subprocess

from pathlib import Path

GITLAB_API_URL="https://gitlab.diamond.ac.uk/api/v4"
# The release lives with the packages it ships, not with this layer.  Passing
# --repo explicitly also means the script does not depend on being run from a
# particular checkout.
GITHUB_REPO = 'PandABlocks/PandABlocks-FPGA'


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('tag', help='The tag of the release to fetch')
    return parser.parse_args()


def get_links(tag):
    return requests.get(
        f'{GITLAB_API_URL}/projects/7925/releases/{tag}/assets/links').json()


def get_slowfpga_links(tag):
    return requests.get(
        f'{GITLAB_API_URL}/projects/7758/releases/{tag}/assets/links').json()


def main():
    args = parse_args()
    os.makedirs(f'release-{args.tag}', exist_ok=True)
    names = []
    for link_info in get_links(args.tag) + get_slowfpga_links(args.tag):
        name = link_info['name']
        names.append(name)
        url = link_info['direct_asset_url']
        if Path(f'release-{args.tag}/{name}').exists():
            print(f'Skipping {name}, already exists')
            continue

        print(f'Downloading {name}')
        response = requests.get(url)
        response.raise_for_status()
        with open(f'release-{args.tag}/{name}', 'wb') as f:
            f.write(response.content)

    subprocess.run(['tar', '-czf', f'panda-fpga-ipks-{args.tag}.tar.gz', '-C',
                    f'release-{args.tag}'] + names, check=True)
    subprocess.run(['gh', 'release', 'create', args.tag, '--repo', GITHUB_REPO,
                    '--generate-notes', '--fail-on-no-commits', '--prerelease'],
                    check=False)
    subprocess.run(['gh', 'release', 'upload', '--clobber', args.tag,
                    '--repo', GITHUB_REPO,
                    f'panda-fpga-ipks-{args.tag}.tar.gz'], check=True)


if __name__ == '__main__':
    main()
