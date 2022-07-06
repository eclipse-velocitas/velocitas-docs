#!/bin/bash
# This script is executed after the creation of a new container

git clone https://github.com/google/docsy.git themes/docsy
npm i -g postcss postcss-cli autoprefixer