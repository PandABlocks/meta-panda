#!/usr/bin/env python
import argparse
import requests
import subprocess
import os

GITLAB_API_URL="https://gitlab.diamond.ac.uk/api/v4"


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('tag', help='The tag of the release to fetch')
    return parser.parse_args()


def get_links(tag):
    return requests.get(
        f'{GITLAB_API_URL}/projects/8000/releases/{tag}/assets/links').json()


def main():
    args = parse_args()
    os.makedirs(f'release-{args.tag}', exist_ok=True)
    for link_info in get_links(args.tag):
        name = link_info['name']
        url = link_info['direct_asset_url']
        print(f'Downloading {name}')
        response = requests.get(url)
        response.raise_for_status()
        with open(f'release-{args.tag}/{name}', 'wb') as f:
            f.write(response.content)

    subprocess.run(['gh', 'release', 'create', args.tag,
                    f'release-{args.tag}/*'], check=True)


if __name__ == '__main__':
    main()
