#!/bin/bash

# This script will download the complete source package group
# based on the following files which define the groupings
# of installed packages:

# pkgs_pre_provision.txt  - initial packages installed in base Ubuntu image
# pkgs_post_provision.txt - packages installed by vagrant configuration
# pkgs_python.txt         - python packages installed via `pip`
#
# ref: http://askubuntu.com/questions/167468/where-can-i-find-the-source-code-of-ubuntu

download() {
    BASEDIR=`pwd`
    DIRNAME=$BASEDIR/$1
    PKGLIST=$BASEDIR/../pkglists/$2

    mkdir $DIRNAME &> /dev/null
    cd $DIRNAME

    for pkg in `cat $PKGLIST | awk '{ print $1 }'`; do
        echo "===== Package: $pkg ====="
        yumdownloader --downloadonly --source -d $pkg
    done

    cd $BASEDIR
}

## CREATE DIFF PACKAGE LIST
if [ ! -e pkglists/pkgs_newly_installed.txt ]; then
    sort installed_pkgs_pre_provision.txt > /tmp/sorted_pre.txt
    sort installed_pkgs_post_provision.txt > /tmp/sorted_post.txt

    # test that we are working on fresh data
    if [[ $(stat -c%s /tmp/sorted_pre.txt) -eq $(stat -c%s /tmp/sorted_post.txt) ]]; then
        echo "Error: Package files are the same size!"
        echo "Make sure to run this on a freshly created virtual machine"
        exit 1
    fi
    comm -13 /tmp/sorted_pre.txt /tmp/sorted_post.txt | cut -f1 > pkglists/pkgs_newly_installed.txt
    cp installed_pkgs_pre_provision.txt pkglists/pkgs_pre_provision.txt
    cp installed_pkgs_python.txt pkglists/pkgs_python.txt
else
    echo "pkglists already generated ... skipping to download."
fi

SOURCEDIR=`pwd`/source_downloads
cd $SOURCEDIR

## DOWNLOAD BASE PACKAGES
DIR=sources-base-packages
PKGLIST=pkgs_pre_provision.txt

echo "Downloading source packages from $PKGLIST to $DIR"
download $DIR $PKGLIST &> log_download_${DIR}.log

## DOWNLOAD ADDED PACKAGES
DIR=sources-added-packages
PKGLIST=pkgs_newly_installed.txt

echo "Downloading source packages from $PKGLIST to $DIR"
download $DIR $PKGLIST &> log_download_${DIR}.log

## DOWNLOAD PYTHON PACKAGES
DIR=sources-python-packages
mkdir $DIR &> /dev/null
echo "Downloading python packages to $DIR"
pip install --no-use-wheel -d $DIR -r `pwd`/pkglists/pkgs_python.txt --allow-external django-admin-tools --allow-unverified django-admin-tools &> log_download_pkgs_python.log
