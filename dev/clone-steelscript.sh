#!/bin/bash

# Bootstrap development script that
# git clones all steelscript repos to current directory

BASEURL=git@gitlab.lab.nbttech.com:steelscript

REPOS="reschema
steelscript
steelscript-appfwk
steelscript-appfwk-business-hours
steelscript-cmdline
steelscript-netprofiler
steelscript-netshark
steelscript-steelhead
steelscript-wireshark"

for REPO in $REPOS
do
    if [ ! -e $REPO ]; then
        echo "*****"
        echo ${REPO}
        echo "*****"
        git clone $BASEURL/${REPO}.git
        cd $REPO
        git submodule update --init --recursive
        git checkout develop
        cd ..
    fi
done

SCRIPT="rungit"
if [ ! -e $SCRIPT ]; then
cat > $SCRIPT << "EOF"
#!/bin/zsh

for d in `ls | grep "^steelscript"`; do
    echo "*********\n$d"
    cd $d
    git $*
    cd ..
done
EOF
chmod +x $SCRIPT
fi

SCRIPT="reinstall.sh"
if [ ! -e $SCRIPT ]; then
cat > $SCRIPT << "EOF"
#!/bin/bash
#
# Options
# -u uninstall only
# -e install editable (pip install -e .)
# -d install deps too (default no-deps)
#

UNINSTALL=false
EDITABLE=false
INSTALL_DEPS=false

while [[ $# > 0 ]]
do
    key="$1"

    case $key in
        -u|--uninstall)
        UNINSTALL=true
        ;;
        -e|--editable)
        EDITABLE=true
        ;;
        -d|--install-deps)
        INSTALL_DEPS=true
        ;;
        *)
        echo "SteelScript reinstall helper script"
        echo "Options:"
        echo " -u uninstall only"
        echo " -e install editable (pip install -e .)"
        echo " -d install deps too (default no-deps)"
        exit
        ;;
    esac
    shift # past argument or value
done

# setup pip command
PIP_ARGS=""
if [[ $INSTALL_DEPS == false ]]; then
    PIP_ARGS=$PIP_ARGS"--no-deps "
fi

if [[ $EDITABLE == true ]]; then
    PIP_ARGS=$PIP_ARGS"-e "
fi

# verify virtualenv
if [ -z $VIRTUAL_ENV ]; then
    echo 'Activate a virtualenv first.'
    exit
else
    . $VIRTUAL_ENV/bin/activate
fi

# go to vagrant repo folder if not already in a suitable location
DIRS=$(ls | grep "^steelscript")
if [[ $DIRS == "" ]]; then
    cd /src
    DIRS=$(ls | grep "^steelscript")
fi

for d in $DIRS; do
    echo "*********"
    echo "$d"
    cd $d

    # handle two different types of setup.py configs
    NAME=$(grep \'name\' setup.py | cut -d\' -f4)
    if [[ $NAME == "" ]]; then
        NAME=$(grep 'name=' setup.py | cut -d\' -f2)
    fi

    echo pip uninstall --yes $NAME
    pip uninstall --yes $NAME
    rm -rf *egg-info

    # any arg will disable install
    if [[ $UNINSTALL == false ]]; then
        echo pip install $PIP_ARGS .
        pip install $PIP_ARGS .
    fi

    cd ..
done
EOF
chmod +x $SCRIPT
fi
