This directory contains lists of packages installed into the virtual machine.

  - pkgs_pre_provision.txt  - initial packages installed in base Ubuntu image
  - pkgs_post_provision.txt - packages installed by vagrant configuration
  - pkgs_python.txt         - python packages installed via `pip`

These files will be created by the script in the above directory called
`download_source_packages.sh`.
