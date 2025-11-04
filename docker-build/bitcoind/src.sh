#!/bin/bash
VERSION="v30.0"
SRC="https://github.com/bitcoin/bitcoin/archive/refs/tags/${VERSION}.tar.gz"
echo $SRC
wget -O package.tar.gz $SRC
rm -r .src
mkdir .src
tar xzf package.tar.gz --strip-components 1 -C .src
rm package.tar.gz
