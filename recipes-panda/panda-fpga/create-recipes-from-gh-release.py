#!/usr/bin/env python
import argparse
import glob
import json
import os
import re
import subprocess


DEFAULT_OWNER = 'PandABlocks'
DEFAULT_REPO = 'PandABlocks-FPGA'
VALID_MACHINES = ('pandabox', 'xu5-st1')
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--owner', default=DEFAULT_OWNER)
    parser.add_argument('--repo', default=DEFAULT_REPO)
    parser.add_argument('--delete-existing', action='store_true')
    parser.add_argument('--dry-run', action='store_true')
    parser.add_argument(
        '--regexp', default='panda-',
        help='Only process assets matching this regexp')
    parser.add_argument(
        'release_tag', help='Github release tag to download assets from')
    return parser.parse_args()


def get_assets_info(owner, repo, release_tag):
    command = ['gh', 'release', 'view',
               '--repo', f'{owner}/{repo}', '--json', 'assets', release_tag]
    output = subprocess.check_output(command)
    return json.loads(output)['assets']


def handle_fpga(asset, args):
    name = asset['name'].replace('@', '_')[:-4]
    if args.delete_existing:
        pkg_name = name.split('_')[0]
        for old_recipe in glob.glob(f'{pkg_name}*.bb'):
            print(f'Deleting existing recipe {old_recipe}')
            if not args.dry_run:
                os.remove(old_recipe)

    recipe_name = f'{name}.bb'
    url = asset['url']
    digest = asset['digest']
    assert digest.startswith('sha256:')
    sha256 = digest[len('sha256:'):]
    print(f'Creating recipe {recipe_name}')
    content = f'''require panda-fpga.inc

SRC_URL = "{url}"
SRC_URI[sha256sum] = "{sha256}"
'''
    if args.dry_run:
        print("== DRY RUN ==")
        print(content)
        print("=============")
    else:
        with open(recipe_name, 'w') as f:
            f.write(content)


def handle_fpga_boot(asset, args):
    INCLUDE_FILE = 'panda-fpga-boot-uris.inc'
    name = asset['name'].replace('@', '_')[:-4]
    version = name.split('_')[1]
    if args.delete_existing:
        if not args.dry_run:
            os.remove(INCLUDE_FILE)

    machine = None
    for item in VALID_MACHINES:
        if version.startswith(item):
            machine = item
            break

    if not machine:
        return

    url = asset['url']
    digest = asset['digest']
    assert digest.startswith('sha256:')
    sha256 = digest[len('sha256:'):]
    content = f'''# {machine}
SRC_URI:{machine} = "{url};name={machine}-boot"
SRC_URI[{machine}-boot.sha256sum] = "{sha256}"
'''
    if args.dry_run:
        print("== DRY RUN ==")
        print(content)
        print("=============")
    else:
        with open(INCLUDE_FILE, 'a') as f:
            f.write(content)


def main():
    args = parse_args()
    os.chdir(SCRIPT_DIR)
    assets_info = get_assets_info(args.owner, args.repo, args.release_tag)
    for asset in assets_info:
        if asset['name'].endswith('ipk') and \
                re.search(args.regexp, asset['name']):
            if asset['name'].startswith('panda-fpga-boot'):
                handle_fpga_boot(asset, args)
            else:
                handle_fpga(asset, args)


if __name__ == '__main__':
    main()
