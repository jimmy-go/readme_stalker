#!/bin/bash
## Validates all params are supplied.

printUsage() {
    echo "  usage: ./<SCRIPT>.sh <USERNAME> <BRANCH> <PERSONAL_TOKEN>"
}

USR=$1
if [ -z "$USR" ]; then
    echo "User not set"
    printUsage;
    exit 1;
fi
BRANCH=$2
if [ -z "$BRANCH" ]; then
    echo "Branch not set"
    printUsage;
    exit 1;
fi
TOKEN=$2
if [ -z "$TOKEN" ]; then
    echo "TOKEN not set"
    printUsage;
    exit 1;
fi
export USR;
export BRANCH;
export TOKEN;
