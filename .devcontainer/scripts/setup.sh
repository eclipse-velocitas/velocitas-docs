#! /bin/sh
rm -rf themes/docsy
git clone https://github.com/google/docsy.git themes/docsy
cd themes/docsy
export NODE_PATH=$NODE_PATH:`npm root -g`
npm install -g npm
npm install -g postcss postcss-cli autoprefixer
npm install
