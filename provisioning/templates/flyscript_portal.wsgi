# Copyright (c) 2013 Riverbed Technology, Inc.
# This software is licensed under the terms and conditions of the MIT License set
# forth at https://github.com/riverbed/flyscript-vm-config/blob/master/LICENSE
# ("License").  This software is distributed "AS IS" as set forth in the License.


import os
import sys

os.environ['DJANGO_SETTINGS_MODULE'] = 'project.settings'
os.environ['HOME'] = '${project_root_deploy}'
sys.path.append('${project_root_deploy}/${project_name}')

import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()
