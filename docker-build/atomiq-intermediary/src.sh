#!/bin/bash
rm -r .src
git clone -b main --single-branch https://github.com/atomiqlabs/atomiq-lp .src
cp -f .env .src/
