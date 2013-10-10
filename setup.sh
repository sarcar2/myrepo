#!/bin/bash
# Simple setup.sh for configuring Ubuntu 12.04 LTS EC2 instance
# for headless setup. 

# https://github.com/creationix/nvm
sudo apt-get install -y git-core

# Install emacs24
# https://launchpad.net/~cassou/+archive/emacs
sudo apt-add-repository -y ppa:cassou/emacs
sudo apt-get update
sudo apt-get install -y emacs24 emacs24-el emacs24-common-non-dfsg

# Install cscope
sudo apt-get install -y cscope cscope-el

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

##########################
# R related installation #
##########################
sudo apt-get install -y r-base
# Install ESS: R code within emacs
sudo apt-get install -y ess

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
if [ (-d .ssh/) -a ( -a .ssh/config]; then
    mv .ssh/config .ssh/config.old
fi
popd

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
ln -sb dotfiles/.env_custom/.sshconfig_custom .ssh/config
popd
# -----------------------------------------------------

# Common C++ Development Libraries 

# Install latest gcc 
sudo apt-get install -y gcc

# Install common C++ packages: boost
sudo apt-get install -y libboost-all-dev

# Install latest compile accelerators
sudo apt-get install -y cmake distcc ccache

# Install common google packages
# libgoogle-perftools-dev includes tcmalloc
sudo apt-get install -y libprotobuf-dev libgtest-dev libgoogle-perftools-dev libsnappy-dev libleveldb-dev

# Google libgtest-dev static libraries not installed as binary: Build it
pushd /tmp
mkdir -p .build
cd .build
sudo cmake -DCMAKE_BUILD_TYPE=RELEASE /usr/src/gtest/
sudo make
sudo mv libg* /usr/lib
popd

# Google libgoogle-glog-dev and libgflags-dev not available for Ubuntu 12.04

# -----------------------------------------------------

# -----------------------------------------------------

# Common R Packaages ----------------------------------

# Install latest packages not available in binary distribution by executing install within R
R -e "install.packages(\"pysch\"); install.packages(\"sm\");"

