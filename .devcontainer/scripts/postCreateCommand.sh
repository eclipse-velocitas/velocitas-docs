#! /bin/bash
echo "#######################################################"
echo "### Install npm and hugo mod                        ###"
echo "#######################################################"
export NODE_PATH=$NODE_PATH:`npm root -g`
npm install -g npm
npm install -g postcss postcss-cli autoprefixer
npm install
hugo mod get -u github.com/google/docsy@v0.6.0


# add repo to git safe.directory & fix hugo issue with server start
REPO=$(pwd)
git config --global --add safe.directory $REPO

echo "#######################################################"
echo "### Done!!!                                         ###"
echo "#######################################################"
