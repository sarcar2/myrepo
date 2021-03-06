#!/bin/bash
# Simple setup.sh for configuring Ubuntu 12.04 LTS EC2 instance
# for headless setup. 

# Validate that the command is executed where setup.sh and 
# dotfiles are available: else terminate execution of script
# and spew out a WARNING sign and exit
if [ ! -f setup.sh ]; then
    echo "Execute setup.sh from the directory where setup.sh exists"
    exit 2  
fi
if [ ! -d dotfiles ]; then
    echo "Execute setup.sh from the directory where dotfiles exists"
    exit 2  
fi

#
# Machine Setup: Assumed that Machine Setup instructions have been executed: refer to 
# tips/system_commands.txt
#

# Upgrade to the latest packages: remove obsoleted packages
sudo apt-get -y upgrade

#############
# UTILITIES #
#############
# tree: displays directory tree in color
sudo apt-get install -y tree
# rlwrap: command completion and history 
sudo apt-get install -y rlwrap
# Install screen
sudo apt-get install -y screen 
# rlwrap: command completion and history
sudo apt-get install -y rlwrap
# iftop: Command line tool that displays bandwidth usage on an interface
sudo apt-get install -y iftop
# git: distributed version control system
sudo apt-get install -y git-core
# dos2unix: removed CR & LF in dos files to LF for unix
sudo apt-get install -y dos2unix
# lshw: Hardware Lister
sudo apt-get install -y lshw
# hwloc/lstopo: provides a portable abstraction of hierarchical architectures 
sudo apt-get install -y hwloc
# sysstat: sar (system activity report) and iostat monitoring commands
sudo yum install -y sysstat
# telnet client: provided by default
# graphviz: rich set of graph drawing tools e.g. contains dot tool
# used by doxygen to display relationships
sudo apt-get install -y graphviz-dev
# sshpass: allows one to execute ssh without submitting password:
# sshpass -p 'passwd' ssh user@host command...
sudo apt-get install -y sshpass

############################
# SW Development Utilities #
############################
# -----------------------------------------------------
# Install emacs24
# https://launchpad.net/~cassou/+archive/emacs
sudo apt-add-repository -y ppa:cassou/emacs
sudo apt-get update
sudo apt-get install -y emacs24 emacs24-el emacs24-common-non-dfsg
# Install cscope
sudo apt-get install -y cscope cscope-el
# gdb: GNU debugger
sudo apt-get install -y gdb
# doxygen: Documentation system for C, C++, Java, Python and other languages
sudo apt-get intall -y doxygen
# -----------------------------------------------------

# -----------------------------------------------------
# Common C++ Development Libraries 
# Install latest gcc 
sudo apt-get install -y gcc

# Install latest compile accelerators
sudo apt-get install -y cmake distcc ccache

# Install common C++ packages: boost
sudo apt-get install -y libboost-all-dev

# Install common google packages
# libgoogle-perftools-dev includes tcmalloc
sudo apt-get install -y libprotobuf-dev libgtest-dev libgoogle-perftools-dev libsnappy-dev libleveldb-dev libgoogle-glog-dev libgflags-dev

# Google libgtest-dev static libraries not installed as binary: Build it
# Still required with Ubuntu 13.10+
pushd /tmp
mkdir -p .build
cd .build
sudo cmake -DCMAKE_BUILD_TYPE=RELEASE /usr/src/gtest/
sudo make
sudo mv libg* /usr/lib
popd
# -----------------------------------------------------

###################################
# JAVASCRIPT related installation #
###################################
#############################
# Node related installation #
#############################
# Install nvm: node-version manager
curl https://raw.github.com/creationix/nvm/master/install.sh | sh

# Load nvm and install latest production node
source $HOME/.nvm/nvm.sh
nvm install v0.10.12
nvm use v0.10.12

# Install jshint to allow checking of JS code within emacs
# http://jshint.com/
npm install -g jshint

# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y rlwrap

###############################
# PYTHON related installation #
###############################
sudo apt-get install -y pychecker

###############################
# HEROKU related installation #
###############################
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sudo -S sh

##########################
# R related installation #
##########################
# -----------------------------------------------------
sudo apt-get install -y r-base
# Install ESS: R code within emacs
sudo apt-get install -y ess
# Common R Packages ----------------------------------

# Installation of rgl package gave error:
# > "configure: error: missing required header GL/gl.h...
# >  * removing ‘/home/asarcar/R/x86_64-pc-linux-gnu-library/2.15/rgl’"
# Hence used the ubuntu binary distribution:
sudo apt-get install -y r-cran-rgl

# R Package Installation is very unstable: for now commenting out the directory
## Install latest packages not available in binary distribution by executing install within R
# mkdir -p R
## TODO: current all libraries for all R versions and 
## for all architectures will go in same directory
# R -e "install.packages(c('gclus', 'ggplot2', 'pysch', 'sm'), lib='~/R')"
# -----------------------------------------------------

# -----------------------------------------------------
# install dotfiles
# move prior incarnation of dotfiles to an old directory
pushd $HOME
if [ -d ./dotfiles/ ]; then
    mv dotfiles dotfiles.old
fi
if [ -d .emacs.d/ ]; then
    mv .emacs.d .emacs.d~
fi
if [ -d .env_custom/ ]; then
    mv .env_custom .env_custom~
fi
if [ -d .ssh/ ]; then
    if [ -f .ssh/config ]; then
        mv .ssh/config .ssh/config.old
    fi
fi
# pop out of $HOME directory
popd

########################
# Personal Environment #
########################
# Copy the new dotfiles inside this git directory to $HOME
cp -r dotfiles $HOME
pushd $HOME
ln -sb dotfiles/.screenrc .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bashrc .
ln -sf dotfiles/.emacs.d .
ln -sf dotfiles/.Rprofile .
ln -sb dotfiles/.gitignore .
ln -sf dotfiles/.env_custom .
ln -sb dotfiles/.env_custom/.gitconfig_custom .gitconfig
# ln messes up the permission of .ssh/config file - cp instead
# ln -sb ~/dotfiles/.env_custom/.sshconfig_custom .ssh/config
cp ~/dotfiles/.env_custom/.sshconfig_custom .ssh/config
popd
# -----------------------------------------------------

