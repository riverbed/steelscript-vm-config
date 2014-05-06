#!/usr/bin/sh

LOGDIR=/var/log/apache2
export ERROR_LOG=$LOGDIR/error.log
export ACCESS_LOG=$LOGDIR/other_vhosts_access.log
USERGROUP=www-data


export PORTAL_LOG=/var/www/flyscript_portal/log.txt

export PORTAL_STAGE_DIR=/steelscript/steelscript_appfwk
export PORTAL_STAGE_VENV=/steelscript/virtualenv
export PORTAL_DEPLOY_DIR=/var/www/steelscript_appfwk
export PORTAL_DEPLOY_VENV=/var/www/virtualenv

alias portal_view_err_log='less $ERROR_LOG'
alias portal_view_access_log='less $ACCESS_LOG'
alias portal_view_portal_log='less $PORTAL_LOG'

alias cdportal='cd $PORTAL_STAGE_DIR'
alias cdwww='cd $PORTAL_DEPLOY_DIR'
alias cdshared='cd /vagrant'

alias portal_dev_server='$PORTAL_STAGE_VENV/bin/python $PORTAL_STAGE_DIR/manage.py runserver `facter ipaddress`:8000'
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
portal_update() {
    echo "Pulling latest changes from github ..."
    cd /vagrant/provisioning
    ansible-playbook -i ansible_hosts -c local stage.yml --extra-vars "force_checkout=yes"
    cd -
}

#
# Push changes from staging area to apache
#
portal_deploy() {
    rotate_logs
    echo "Deploying files ..."
    cd /vagrant/provisioning
    ansible-playbook -i ansible_hosts -c local deploy.yml
    cd -
}

portal_clean_perms() {
    # update all perms correctly in staging dir
    echo -n "Updating Portal ownership ... "
    cdportal
    sudo chown -R vagrant:vagrant *
    cd -
    echo "done."
}

portal_reset_dev() {
    # run a clean --reset on the deployed directory
    echo "Resetting development server configuration ..."
    echo "Are you sure?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) break;;
            No ) return;;
        esac
    done

    virtualenv_dev
    cdportal
    sudo ./clean --reset --force
    deactivate
    cd -
}

portal_reset_www() {
    # run a clean --reset on the deployed directory
    echo "Resetting deployed server configuration ..."
    echo "Are you sure?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) break;;
            No ) return;;
        esac
    done

    virtualenv_www
    cdwww
    sudo ./clean --reset --force
    deactivate
    cd -
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
