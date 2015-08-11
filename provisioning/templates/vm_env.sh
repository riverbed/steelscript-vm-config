#!/usr/bin/sh

# basic environment config
export TERM=xterm-256color
# disable default which overwrites terminal title
export PROMPT_COMMAND=
alias ls='ls --color'

export PROJECT_DEV_DIR={{ project_root_devel }}
export PROJECT_DEV_VENV={{ virtualenv_devel }}
export PROJECT_DEV_SITEPKGS=$PROJECT_DEV_VENV/lib/python2.7/site-packages

export PROJECT_APACHE_DIR={{ project_root_apache }}
export PROJECT_APACHE_VENV={{ virtualenv_apache }}
export PROJECT_APACHE_SITEPKGS=$PROJECT_APACHE_VENV/lib/python2.7/site-packages

APACHE_LOGDIR=/var/log/httpd
export ERROR_LOG=$APACHE_LOGDIR/error.log
export ACCESS_LOG=$APACHE_LOGDIR/other_vhosts_access.log
USERGROUP=apache

export DEV_LOGDIR=$PROJECT_DEV_DIR/logs

alias view_err_log='less $ERROR_LOG'
alias view_access_log='less $ACCESS_LOG'
alias view_project_log='less $DEV_LOGDIR/log.txt'

alias cdproject='cd $PROJECT_DEV_DIR'
alias cdwww='cd $PROJECT_APACHE_DIR'
alias cdshared='cd /vagrant'
alias cdsitepackages='cd $PROJECT_DEV_SITEPKGS'

# Development aliases
{% if deployment_type == 'development' %}
export PROGRESSD_DIR={{ steelscript_sources }}/steelscript-appfwk/steelscript/appfwk/progressd
{% else %}
export PROGRESSD_DIR=$PROJECT_APACHE_SITEPKGS/steelscript/appfwk/progressd
{% endif %}

alias start_progressd='cd $PROGRESSD_DIR && python progressd.py --path $PROJECT_DEV_DIR'
alias start_celery='cd $PROJECT_DEV_DIR && rm -f logs/celery.txt && python manage.py celery worker -l DEBUG -f logs/celery.txt -c4 -n worker1.%h'
alias start_flower='cd $PROJECT_DEV_DIR && python manage.py celery flower --port=8888'
alias start_appfwk='cd $PROJECT_DEV_DIR && python manage.py runserver 0.0.0.0:8000'

alias appfwk_dev_server='cdproject && $PROJECT_DEV_VENV/bin/python $PROJECT_DEV_DIR/manage.py runserver `facter ipaddress`:8000'
alias run_ipython_notebook='mkdir -p ~/ipython_notebooks && cd ~/ipython_notebooks && ipython notebook --ip=`facter ipaddress` --no-browser'

alias virtualenv_dev='deactivate &>/dev/null; source $PROJECT_DEV_VENV/bin/activate'
alias virtualenv_www='deactivate &>/dev/null; source $PROJECT_DEV_VENV/bin/activate'

#
# Create manage.py alias for operating on apache appfwk site
# Enables operations like so:
#  > manage shell_plus
#  > manage collectstatic
#  > manage reload
# etc
#
alias manage='cdwww && sudo -u {{ project_owner_apache }} /home/vagrant/virtualenv/bin/python manage.py'

# Activate virtual environment by default on login
virtualenv_dev

# Scheduler setup
export SCHEDULER_DIR=/steelscript/scheduler
export SUPERVISORD_LOG=$SCHEDULER_DIR/supervisord.log
export SCHEDULER_LOG=$SCHEDULER_DIR/scheduler.log

alias cdscheduler='cd $SCHEDULER_DIR'
alias start_scheduler='sudo supervisord -c /steelscript/scheduler/supervisord.conf'
alias stop_scheduler='sudo kill `cat /steelscript/scheduler/supervisord.pid`'

alias view_supervisor_log='sudo less $SUPERVISORD_LOG'
alias view_scheduler_log='sudo less $SCHEDULER_LOG'

upgrade_packages_from_dir() {
    PKGDIR=$1

    for PKG in `ls $PKGDIR`; do
        /home/vagrant/virtualenv/bin/pip install -U --no-deps $PKGDIR/$PKG
    done
    appfwk_restart_services
}

appfwk_clean_pyc() {
    cdwww
    echo -n "Cleaning up old pyc files ... "
    sudo find . -name "*.pyc" -exec rm {} \;
    echo "done."
}

appfwk_restart_services() {
    echo "Restarting App Framework services ... "
    sudo service progressd restart
    sudo service celeryd restart
    sudo service httpd restart
}

appfwk_clean_permissions() {
    # update all perms correctly in staging dir
    CURDIR=`pwd`
    echo -n "Updating app framework development ownership ... "
    cdproject
    sudo chown -R {{ project_owner_devel }}:{{ project_group_devel }} *
    echo "done."
    echo -n "Updating app framework apache ownership ... "
    cdwww
    sudo chown -R {{ project_owner_apache }}:{{ project_group_apache }} *
    echo "done."
    appfwk_clean_pyc
    appfwk_restart_services
    cd $CURDIR
}

rotate_logs() {
    echo -n "Rotating apache logs ... "
    sudo logrotate -f /etc/logrotate.d/apache2
    echo "done."
}

appfwk_collect_logs() {
    echo -n "Collecting all log files and generating zipfile ... "
    cdwww
    sudo $PROJECT_APACHE_VENV/bin/python manage.py collect_logs &> /dev/null
    LOGFILE=`ls -tr1 | grep debug | tail -1`

    if [[ -e /vagrant ]]; then
        ZIPFILE=/vagrant/appfwk_logs_`date +%d%m%y-%H%M%S`.tar.gz
    else
        ZIPFILE=~/appfwk_logs_`date +%d%m%y-%H%M%S`.tar.gz
    fi

    tar czf $ZIPFILE $LOGFILE $ERROR_LOG $ACCESS_LOG $PORTAL_LOG
    cd -
    echo "done."
    echo "Zip file has been stored here: $ZIPFILE"
    if [[ -e /vagrant ]]; then
        echo "This file should also appear in your host system in the vagrant directory."
    fi
}
