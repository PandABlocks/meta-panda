#!/usr/bin/env python
import argparse
import glob
import hashlib
import os
import re
import requests

GITLAB_API_URL="https://gitlab.diamond.ac.uk/api/v4"


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('tag', help='The tag of the release to fetch')
    return parser.parse_args()


def get_links(tag):
    return requests.get(
        f'{GITLAB_API_URL}/projects/7925/releases/{tag}/assets/links').json()


def remove_old_recipes(pkg_name):
    for old_recipe in glob.glob(f'{pkg_name}*.bb'):
        print(f'Deleting existing recipe {old_recipe}')
        os.remove(old_recipe)


def get_sha256_from_url(url):
    print(f'Fetching {url} to compute sha256')
    response = requests.get(url)
    response.raise_for_status()
    return hashlib.sha256(response.content).hexdigest()


def handle_fpga_boot(link_info):
    # Remove _all.ipk ending
    name = link_info['name'][:-8]
    version = name.split('_')[1]
    machine = version.split('-')[0]
    url = link_info['direct_asset_url']
    print(f'FPGA boot asset URL: {url}')
    INCLUDE_FILE = 'panda-fpga-boot-uris.inc'
    sha256 = get_sha256_from_url(url)
    with open(INCLUDE_FILE, 'r') as f:
        content = f.read()

    content = re.sub(
        rf'SRC_URI:{machine} = ".*"',
        f'SRC_URI:{machine} = "{url};name={machine}-boot"',
        content, flags=re.MULTILINE)
    content = re.sub(
        rf'SRC_URI\[{machine}-boot\.sha256sum\] = ".*"',
        f'SRC_URI[{machine}-boot.sha256sum] = "{sha256}"',
        content, flags=re.MULTILINE
    )
    with open(INCLUDE_FILE, 'w') as f:
        f.write(content)


def handle_fpga(link_info):
    # Remove _all.ipk ending
    name = link_info['name'][:-8]
    url = link_info['direct_asset_url']
    print(f'FPGA asset URL: {url}')
    remove_old_recipes(name.split('_')[0])
    sha256 = get_sha256_from_url(url)
    content = f'''require panda-fpga.inc

SRC_URI = "{url}"
SRC_URI[sha256sum] = "{sha256}"
'''
    with open(f'{name}.bb', 'w') as f:
        f.write(content)


def main():
    args = parse_args()
    for link_info in get_links(args.tag):
        name = link_info['name']
        if not name.endswith('.ipk'):
            print(f'Skipping {name} (not an ipk)')
            continue

        print(f'Handling {name}')
        if name.startswith('panda-fpga-boot'):
            handle_fpga_boot(link_info)
        elif name.startswith('panda-fpga'):
            handle_fpga(link_info)


if __name__ == '__main__':
    main()
