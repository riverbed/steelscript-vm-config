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
steelscript-vm-config
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
#!/bin/zsh
#
# Args
# -u uninstall only
# -d install deps too (default no-deps)


if [ -z $VIRTUAL_ENV ]; then
    echo 'Activate a virtualenv first.'
    exit
else
    . $VIRTUAL_ENV/bin/activate
fi

for d in `ls | grep "^steelscript"`; do
    echo "*********\n$d"
    cd $d
    NAME=$(grep \'name\' setup.py | cut -d\' -f4)
    pip uninstall --yes $NAME
    rm -rf dist *egg-info

    # any arg will disable install
    if [[ $1 != "-u" ]]; then
        if [[ $1 == "-d" ]]; then
            pip install -e .
        else
            pip install --no-deps -e .

        fi
    fi

    cd ..
done
EOF
chmod +x $SCRIPT
fi
