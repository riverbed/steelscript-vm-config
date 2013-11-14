#!/usr/bin/sh

# make a good guess what type of system we are on
if [[ -e /var/log/apache2 ]]; then
    # e.g. RHEL, CentOS, Fedora, Scientific Linux, etc.
    LOGDIR=/var/log/apache2
    export ERROR_LOG=$LOGDIR/error.log
    export ACCESS_LOG=$LOGDIR/access.log
    USERGROUP=www-data
else
    # e.g. Debian, Ubuntu, etc.
    LOGDIR=/var/log/httpd
    export ERROR_LOG=$LOGDIR/error_log
    export ACCESS_LOG=$LOGDIR/access_log
    USERGROUP=apache
fi


export PORTAL_LOG=/flyscript/flyscript_portal/log.txt

alias view_err_log='less $ERROR_LOG'
alias view_access_log='less $ACCESS_LOG'
alias view_portal_log='less $PORTAL_LOG'

alias cdportal='cd /flyscript/flyscript_portal'
alias cdshared='cd /vagrant'

clean_pycs() {
    # remove all pyc files
    echo -n "Cleaning up all .pyc files ... "
    cdportal
    sudo python manage.py clean_pyc --path .
    echo "done."
}

clean_perms() {
    # update all perms correctly
    echo -n "Updating Portal ownership ... "
    cdportal
    sudo chown -R $USERGROUP:$USERGROUP *
    echo "done."
}

collect_logs() {
    echo -n "Collecting all log files and generating zipfile ... "
    cdportal
    sudo python manage.py collect_logs &> /dev/null
    LOGFILE=`ls -tr1 | grep debug | tail -1`

    if [[ -e /vagrant ]]; then
        ZIPFILE=/vagrant/portal_logs_`date +%d%m%y-%H%M%S`.tar.gz
    else
        ZIPFILE=~/portal_logs_`date +%d%m%y-%H%M%S`.tar.gz
    fi

    tar czf $ZIPFILE $LOGFILE $ERROR_LOG $ACCESS_LOG $PORTAL_LOG
    echo "done."
    echo "Zip file has been stored here: $ZIPFILE"
    if [[ -e /vagrant ]]; then
        echo "This file should also appear in your host system in the vagrant directory."
    fi
}
