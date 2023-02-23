#! /bin/sh
export NODE_PATH=$NODE_PATH:`npm root -g`
npm install -g npm
npm install -g postcss postcss-cli autoprefixer
npm install
