#!/bin/bash

# Wrapper for a couple of helpful ansible commands

# Available commands:
#   deploy
#   update
#   help

OPTIND=1

BASE_CMD="ansible-playbook -u vagrant --private-key=provisioning/keys/vagrant -i vagrant_ansible_inventory_default"
PLAYBOOK="provisioning/deploy.yml"
VERBOSE=0
EXTRA_ARGS=""

deploy() {
    echo 'Running deployment command ...'
    while getopts "h?vr:" OPTION "$@"; do
        case $OPTION in
            h|\?) 
                help
                exit 0
                ;;
            v)
                VERBOSE=1
                BASE_CMD="$BASE_CMD -vvvv"
                ;;
            r)
                vars="--extra-vars 'rsync_source=$OPTARG' --extra-vars 'local_dir=`pwd`/'"
                EXTRA_ARGS="$EXTRA_ARGS $vars"
                PLAYBOOK="provisioning/local_deploy.yml"
                ;;
        esac
    done

    CMD="$BASE_CMD $EXTRA_ARGS $PLAYBOOK"

    if [[ $VERBOSE == 1 ]]; then
        echo "Command: $CMD"
    fi
    exec $CMD
}

update() {
    echo 'Running update command ...'
    CMD="$BASE_CMD provisioning/stage.yml"
    exec $CMD
}

help() {
    echo 'This script provides convenience functions to update the Vagrant VM '
    echo 'without logging into the machine.'
    echo 'Additionally, when using the "deploy -r <local_directory>" option'
    echo 'a local copy of the flyscript_portal can be used as the deployment source'
    echo 'so you can perform all of your development in your local environment.'
    echo ''
    echo 'Available commands:'
    echo '  deploy [-h] [-r <local_directory>]'
    echo '  update'
    echo '  -h/help'
}


if [[ $1 =~ ^(deploy|update|help)$ ]]; then
  "$@"
else
  echo "Invalid subcommand $1" >&2
  help
  exit 1
fi


