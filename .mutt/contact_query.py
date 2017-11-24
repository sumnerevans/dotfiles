#! /usr/bin/env python3
import subprocess
import sys

if len(sys.argv) != 2:
    raise Exception('Invalid Parameters')

name = sys.argv[1]

try:
    google = ['goobook', 'query', name]
    print(subprocess.check_output(google).decode('utf-8').strip())

    csmdir = ['dirsearch', '--format=mutt', name]
    csmdir = subprocess.check_output(csmdir).decode('utf-8')
    print('\n'.join(csmdir.split('\n')[1:]).strip())
except subprocess.CalledProcessError:
    pass
