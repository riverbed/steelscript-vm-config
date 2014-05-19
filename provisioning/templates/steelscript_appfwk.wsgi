# Copyright (c) 2013 Riverbed Technology, Inc.
# This software is licensed under the terms and conditions of the MIT License set
# forth at https://github.com/riverbed/flyscript-vm-config/blob/master/LICENSE
# ("License").  This software is distributed "AS IS" as set forth in the License.


import os
import sys

os.environ['DJANGO_SETTINGS_MODULE'] = 'local_settings'
os.environ['HOME'] = '{{ project_wsgi }}'
os.environ['DATAHOME'] = '{{ project_wsgi }}'
sys.path.append('{{ project_root_apache }}')

# borrow monkey patch from app framework manage.py module
from manage import find_management_module
import django.core.management
django.core.management.find_management_module = find_management_module


import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()
