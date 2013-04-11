import os
import sys
 
os.environ['DJANGO_SETTINGS_MODULE'] = 'project.settings'
sys.path.append('/flyscript/flyscript_portal')
 
import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()

