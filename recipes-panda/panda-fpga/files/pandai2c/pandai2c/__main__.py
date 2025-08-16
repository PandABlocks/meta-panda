#!/usr/bin/env python

import argparse
import errno
import sys

from pandai2c import ini_file, eeprom, parse_ipmi, create_ipmi


def parse_args():
    parser = argparse.ArgumentParser(description='flash data to FMC EEPROM')
    subparsers = parser.add_subparsers(dest='command', required=True)
    # Check sub-command
    check_parser = subparsers.add_parser(
        'check', help='Check the FMC EEPROM against an IPMI file')
    check_parser.add_argument(
        'ini_path', type=str, help='Path to IPMI definition file')
    # Dump sub-command
    dump_parser = subparsers.add_parser(
        'dump', help='Dump the contents of the FMC EEPROM')
    dump_parser.add_argument(
        '-b', '--binary', action='store_true', default=False,
        help='Dump raw EEPROM image')
    dump_parser.add_argument(
        '--path', type=str, default='',
        help='Path to field, e.g. \'Board.product name\'')
    # Select sub-command
    select_parser = subparsers.add_parser(
        'select',
        help='Among the IPMI files passed as argument, output the one that '
             'matches the FMC EEPROM')
    select_parser.add_argument(
        'ini_paths', type=str, nargs='+', help='Paths to IPMI definition files')
    # Write sub-command
    write_parser = subparsers.add_parser(
        'write', help='Write to the FMC EEPROM based on a definition file')
    write_parser.add_argument(
        'ini_path', type=str, help='Path to IPMI definition file')

    return parser.parse_args()


def check(args):
    ini = ini_file.load_ini_file(args.ini_path)

    # Read the eeprom key from the [.] section, default to "required" if missing
    try:
        eeprom_key = ini['.']['eeprom']
    except KeyError:
        eeprom_key = 'required'


    if eeprom_key == 'ignore':
        # No FMC card fitted, or FMC has no EEPROM.  Just ignore the EEPROM
        print('Ignoring IPMI EEPROM')
        sys.exit(0)

    # We expect the EEPROM to be present.  First try to read it.
    try:
        image = eeprom.read_eeprom()
    except OSError as e:
        # No such device or address (i.e. no FMC EEPROM detected)
        if e.errno == errno.ENXIO:
            print('FMC was expected but none detected')
            sys.exit(1)
        else:
            print('Unable to read FMC EEPROM:', e)
            sys.exit(1)
    except Exception as e:
        print('Unable to read FMC EEPROM:', e)
        sys.exit(1)

    # Now try to parse the image we've just read
    try:
        ipmi = parse_ipmi.parse(image)
    except Exception as e:
        print('Error parsing FMC EEPROM:', e)
        sys.exit(1)

    # Finally check the parse against the ini file
    try:
        ini_file.compare_ini(ini, ipmi, ignore=['.'])
    except ini_file.CompareFail as e:
        print('FMC EEPROM mismatch:', e)
        sys.exit(1)

    # If we get this far then all is well!
    print('FMC EEPROM matches')
    sys.exit(0)


def dump(args):
    image = eeprom.read_eeprom()
    if args.binary:
        image.tofile(sys.stdout)
    else:
        ipmi = parse_ipmi.parse(image)
        if args.path:
            section, key = args.path.split('.', 1)
            print(str(ipmi[section][key]))
        else:
            ipmi.emit()


def select(args):
    ini_paths = args.ini_paths
    ignore_ones = []
    fmc_ones = []
    for ini_path in ini_paths:
        ini = ini_file.load_ini_file(ini_path)
        if ini.get('.', {}).get('eeprom') == 'ignore':
            ignore_ones.append((ini_path, ini))
        else:
            fmc_ones.append((ini_path, ini))

    # If there are no FMC images, select the first with eeprom='ignore'
    if not fmc_ones:
        print(ignore_ones[0][0])
        sys.exit(0)

    try:
        ipmi = parse_ipmi.parse(eeprom.read_eeprom())
    except Exception as e:
        # if you want to find why, run the check command instead
        # the current sub-command is only to obtain a path as output
        sys.exit(1)

    # Iterate over all FMC ini files until
    for ini_path, ini in fmc_ones:
        try:
            ini_file.compare_ini(ini, ipmi, ignore=['.'])
            print(ini_path)
            sys.exit(0)
        except ini_file.CompareFail as e:
            pass

    # At this point, we can choose only from the ignore ones
    if not ignore_ones:
        sys.exit(1)

    print(ignore_ones[0][0])


def write(args):
    ini = ini_file.load_ini_file(args.ini_path)
    print('Please ensure the FMC is', ini['Board']['product name'])
    serial_number = input('Serial number: ').strip()
    if not serial_number:
        serial_number = None

    ipmi = create_ipmi.generate_ipmi(ini, serial_number)

    try:
        address16bit = ini['.']['eeprom'] == '16-bit'
    except KeyError:
        address16bit = False

    print('Writing EEPROM...')
    eeprom.write_address(data=ipmi, address16bit=address16bit)
    readback = eeprom.read_eeprom(length=len(ipmi))
    if bytes(readback) != bytes(ipmi):
        print('Verification failed')
        sys.exit(1)
    else:
        print('Verification OK')


def main():
    args = parse_args()
    globals().get(args.command)(args)


if __name__ == "__main__":
    main()
