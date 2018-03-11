#!/bin/bash
mkdir -p vendor
git submodule add --force https://github.com/sstephenson/bats vendor/bats
git submodule add --force https://github.com/ztombol/bats-support vendor/bats-support
git submodule add --force https://github.com/ztombol/bats-assert vendor/bats-assert
git submodule update --init --recursive
