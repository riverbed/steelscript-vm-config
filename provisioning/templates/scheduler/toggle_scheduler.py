#!/usr/bin/env python

# Copyright (c) 2014 Riverbed Technology, Inc.
#
# This software is licensed under the terms and conditions of the MIT License
# accompanying the software ("License").  This software is distributed "AS IS"
# as set forth in the License.

"""
Toggles the presence of a line to start the SteelScript scheduler
from the init script rc.local.

When present, the scheduler will start at boot time automatically.
It can still be stopped using the alias "stop_scheduler", and
restarted with "start_scheduler".
"""
import sys

RCPATH = '/etc/rc.local'


def write_file(path, lines):
    try:
        with open(path, 'w') as f:
            f.write('\n'.join(lines))
    except IOError:
        print 'Script must be run as root or with sudo'
        sys.exit()


def toggle_line(path, line):
    data = []
    removed = False
    with open(path, 'r') as f:
        for ln in f:
            if ln.strip() == line:
                removed = True
                continue
            data.append(ln.strip())

    if removed:
        msg = 'Scheduler has been deactivated from starting at boot time.'
    else:
        data[-1:-1] = [line]
        msg = 'Scheduler has been activated to start at boot time.'

    write_file(path, data)
    print msg


if __name__ == '__main__':
    toggle_line(
        RCPATH,
        '/usr/local/bin/supervisord -c /steelscript/scheduler/supervisord.conf'
    )
