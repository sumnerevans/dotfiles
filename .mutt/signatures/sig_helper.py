'''
Signature Helper
'''
import subprocess

homepage = 'https://sumnerevans.com'
cell = '+1 (720) 459-1501'
gpg = 'B50022FD'


def get_quote():
    quotes_cmd = ['fortune', '/home/sumner/.mutt/quotes']
    quote = ''
    # Not sure why, but sometimes fortune returns an empty fortune.
    while len(quote) == 0:
        quote = subprocess.check_output(quotes_cmd).decode('utf-8').strip()

    return quote


def print_contact_info(email):
    print()
    print('Email: {0:30} Homepage: {1}'.format(email, homepage))
    print('Cell:  {0:30} GPG:      {1}'.format(cell, gpg))
    print()
