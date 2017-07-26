#! /usr/bin/env python2

from subprocess import check_output
import re

def get_variable(variable):
    gpg_file = check_output("gpg2 -dq ~/.mutt/passwords.gpg", shell=True)
    gpg_file = gpg_file.decode("utf-8")
    gpg_file = gpg_file.replace("set ", "")
    gpg_file = gpg_file.replace("= ", "")
    gpg_file = gpg_file.replace("\"", "")
    gpg_file = re.sub('\n$', '', gpg_file)
    gpg_file = gpg_file.splitlines()

    variables = {}
    for line in gpg_file:
        variables.update(dict(e.split(' ') for e in line.split(',')))

    return variables[variable]
