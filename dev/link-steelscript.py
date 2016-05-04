#!/usr/bin/env python

# Optionally create symlink to directory of development
# sources, or call external script to populate the dev directory
# with clones of all applicable repos

import os
import sys


FILEDIR = os.path.dirname(os.path.abspath(__file__))
VAGRANTDIR = os.path.dirname(FILEDIR)

DEVDIR = os.path.join(VAGRANTDIR, 'dev')
SOURCESDIR = os.path.join(VAGRANTDIR, 'sources')


def prompt_yn(msg, default_yes=True):
    yn = prompt(msg, choices=['yes', 'no'],
                default=('yes' if default_yes else 'no'))
    return yn == 'yes'


def prompt(msg, choices=None, default=None, password=False):
    if choices is not None:
        msg = '%s (%s)' % (msg, '/'.join(choices))

    if default is not None:
        msg = '%s [%s]' % (msg, default)

    msg += ': '
    value = None

    while value is None:
        value = raw_input(msg)

        if not value:
            if default is not None:
                value = default
            else:
                print 'Please enter a valid response.'

        if choices and value not in choices:
            print ('Please choose from the following choices (%s)' %
                   '/'.join(choices))
            value = None

    return value


def create_symlink(linkto):
    if os.path.exists(SOURCESDIR):
        os.unlink(SOURCESDIR)

    print 'Creating symlink from %s to %s' % (SOURCESDIR, linkto)
    os.symlink(linkto, SOURCESDIR)


def prompt_devpath():
    # get path of existing dev directory, then link to it

    devpath = prompt('Enter absolute path to source development directory')
    if not os.path.exists(devpath):
        print 'Path %s does not exist, please enter valid path.'

    create_symlink(devpath)


def call_clone():
    # link to dev path, then call clone script

    create_symlink(DEVDIR)
    os.system('%s/clone-steelscript.sh' % DEVDIR)


if __name__ == '__main__':
    if os.path.exists(SOURCESDIR):
        print 'Development source directory (%s) already exists.' % SOURCESDIR
        sys.exit()

    if prompt_yn('Create link from existing development directory, or '
                 'clone new repos?'):
        prompt_devpath()
    else:
        call_clone()
