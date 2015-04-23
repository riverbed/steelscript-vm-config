#
#/bin/bash

echo "This script will add upstream remotes to all the steelscript"
echo "repos found in this current directory."
echo ""
echo -n "Enter root path for upstream git repos: "
read root_path

if [ ! -d "$root_path" ]; then
    echo "Path doesn't exist - please enter valid path"
    exit(1)
fi

for d in `ls | grep "^steelscript"`; do
    echo "*********\n$d"
    echo "Adding upstream remote: $root_path/$d"
    cd $d
    git remote add upstream $root_path/$d
    cd ..
done
