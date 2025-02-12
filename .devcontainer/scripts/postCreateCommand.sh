#! /bin/bash
# Copyright (c) 2023-2025 Contributors to the Eclipse Foundation
#
# This program and the accompanying materials are made available under the
# terms of the Apache License, Version 2.0 which is available at
# https://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# SPDX-License-Identifier: Apache-2.0

echo "#######################################################"
echo "### Install npm and hugo mod                        ###"
echo "#######################################################"
export NODE_PATH=$NODE_PATH:`npm root -g`
npm install -g npm
npm install -g postcss postcss-cli autoprefixer
npm install
hugo mod get -u github.com/google/docsy@v0.11.0

# install pre-commit
sudo apt update
sudo apt install -y python3-pip
pip install pre-commit==3.6.0 --break-system-packages

# add repo to git safe.directory & fix hugo issue with server start
REPO=$(pwd)
git config --global --add safe.directory $REPO

echo "#######################################################"
echo "### Done!!!                                         ###"
echo "#######################################################"
