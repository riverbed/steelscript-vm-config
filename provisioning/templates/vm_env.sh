#!/usr/bin/sh
export PROJECT_DEV_DIR={{ project_root_devel }}
export PROJECT_DEV_VENV={{ virtualenv_devel }}

export PROJECT_APACHE_DIR={{ project_root_apache }}
export PROJECT_APACHE_VENV={{ virtualenv_apache }}

APACHE_LOGDIR=/var/log/apache2
export ERROR_LOG=$APACHE_LOGDIR/error.log
export ACCESS_LOG=$APACHE_LOGDIR/other_vhosts_access.log
USERGROUP=www-data

export DEV_LOGDIR=$PROJECT_DEV_DIR/logs

alias view_err_log='less $ERROR_LOG'
alias view_access_log='less $ACCESS_LOG'
alias view_project_log='less $DEV_LOGDIR/log.txt'

alias cdproject='cd $PROJECT_DEV_DIR'
alias cdwww='cd $PROJECT_APACHE_DIR'
alias cdshared='cd /vagrant'

alias portal_dev_server='cdproject && $PROJECT_DEV_VENV/bin/python $PROJECT_DEV_DIR/manage.py runserver `facter ipaddress`:8000'
alias run_ipython_notebook='cd ~/ipython_notebooks && ipython notebook --ip=`facter ipaddress` --pylab=inline'

alias virtualenv_dev='deactivate &>/dev/null; source $PROJECT_DEV_VENV/bin/activate'
alias virtualenv_www='deactivate &>/dev/null; source $PROJECT_DEV_VENV/bin/activate'

rotate_logs() {
    echo -n "Rotating apache logs ... "
    sudo logrotate -f /etc/logrotate.d/apache2
    echo "done."
}

portal_clean_perms() {
    # update all perms correctly in staging dir
    echo -n "Updating Portal ownership ... "
    cdportal
    sudo chown -R vagrant:vagrant *
    cd -
    echo "done."
}

portal_collect_logs() {
    echo -n "Collecting all log files and generating zipfile ... "
    cdwww
    sudo $PORTAL_DEPLOY_VENV/bin/python manage.py collect_logs &> /dev/null
    LOGFILE=`ls -tr1 | grep debug | tail -1`

    if [[ -e /vagrant ]]; then
        ZIPFILE=/vagrant/portal_logs_`date +%d%m%y-%H%M%S`.tar.gz
    else
        ZIPFILE=~/portal_logs_`date +%d%m%y-%H%M%S`.tar.gz
    fi

    tar czf $ZIPFILE $LOGFILE $ERROR_LOG $ACCESS_LOG $PORTAL_LOG
    cd -
    echo "done."
    echo "Zip file has been stored here: $ZIPFILE"
    if [[ -e /vagrant ]]; then
        echo "This file should also appear in your host system in the vagrant directory."
    fi
}
