#!/usr/bin/sh

LOGDIR=/var/log/apache2
export ERROR_LOG=$LOGDIR/error.log
export ACCESS_LOG=$LOGDIR/other_vhosts_access.log
USERGROUP=www-data


export PORTAL_LOG=/var/www/flyscript_portal/log.txt

export PORTAL_STAGE_DIR=/flyscript/flyscript_portal
export PORTAL_STAGE_VENV=/flyscript/virtualenv
export PORTAL_DEPLOY_DIR=/var/www/flyscript_portal
export PORTAL_DEPLOY_VENV=/var/www/virtualenv

alias view_err_log='less $ERROR_LOG'
alias view_access_log='less $ACCESS_LOG'
alias view_portal_log='less $PORTAL_LOG'

alias cdportal='cd $PORTAL_STAGE_DIR'
alias cdwww='cd $PORTAL_DEPLOY_DIR'
alias cdshared='cd /vagrant'

alias dev_server='$PORTAL_STAGE_VENV/bin/python $PORTAL_STAGE_DIR/manage.py runserver `facter ipaddress`:8000'
alias run_ipython_notebook='cd ~/ipython_notebooks && ipython notebook --ip=`facter ipaddress` --pylab=inline'

alias virtualenv_dev='deactivate &>/dev/null; source $PORTAL_STAGE_VENV/bin/activate'
alias virtualenv_www='deactivate &>/dev/null; source $PORTAL_DEPLOY_VENV/bin/activate'

rotate_logs() {
    echo -n "Rotating apache logs ... "
    sudo logrotate -f /etc/logrotate.d/apache2
    echo "done."
}

#
# Pull changes from github to local staging area
#
update_portal() {
    echo "Pulling latest changes from github ..."
    cd /vagrant/provisioning
    ansible-playbook -i ansible_hosts -c local stage.yml
    cd -
}

#
# Push changes from staging area to apache
#
deploy() {
    rotate_logs
    echo "Deploying files ..."
    cd /vagrant/provisioning
    ansible-playbook -i ansible_hosts -c local deploy.yml
    cd -
}

clean_perms() {
    # update all perms correctly in staging dir
    echo -n "Updating Portal ownership ... "
    cdportal
    sudo chown -R vagrant:vagrant *
    cd -
    echo "done."
}

collect_logs() {
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
