#!/bin/sh

command -v foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }

sudo easy_install pip

# has the python dependencies -> paramiko PyYAML jinja2 httplib2
# install libselinux-python on remote nodes using selinux
sudo pip install ansible


