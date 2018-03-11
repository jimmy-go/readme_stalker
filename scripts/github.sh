#!/bin/bash

showUsage() {
    echo "  usage: ./readme_explorer.sh <USERNAME> <BRANCH>"
}

getReadmeHTML() {
    DIR=$1
    REPO=$2
    BRANCH=$3
    if [ -z "$REPO" ]; then
        echo "Repository not set"
        exit
    fi
    if [ -z "$DIR" ]; then
        echo "Directory not set"
        exit
    fi
    if [ -z "$BRANCH" ]; then
        echo "Branch not set"
        exit
    fi

    README=$(echo $REPO | sed "s/\//_/g")
    MD_DIR=$DIR/markdown
    HTML_DIR=$DIR/html

    echo $MD_DIR
    echo $HTML_DIR

    mkdir -p $PWD/$MD_DIR
    mkdir -p $PWD/$HTML_DIR

    curl -s -o ${MD_DIR}/${README}.md https://raw.githubusercontent.com/$REPO/$BRANCH/README.md
    grip --export ${MD_DIR}/${README}.md ${HTML_DIR}/${README}.html
}

mergeAll() {
    USR_DIR=$1
    if [ -z "$USR_DIR" ]; then
        echo "Html directory not set"
        exit
    fi
    OUT_FILE=$2
    if [ -z "$OUT_FILE" ]; then
        echo "Html index not set"
        exit
    fi
    cat ${USR_DIR}/html/*.html > ${OUT_FILE}
}

getRepoList() {
    USR=$1
    if [ -z "$USR" ]; then
        echo "User not set"
        showUsage;
        exit
    fi
    BRANCH=$2
    if [ -z "$BRANCH" ]; then
        echo "Branch not set"
        showUsage;
        exit
    fi

    echo "Running README explorer for: $USR"
    DIR=github/$USR
    mkdir -p $PWD/$DIR

    REPO_JSON=$DIR/repos_${USR}.json
    REPO_LIST=$DIR/$USR.list.txt
    curl -s -o $REPO_JSON https://api.github.com/users/${USR}/repos

    grep '"full_name"' $REPO_JSON | sed "s/[ :,\"]//g;s/full_name//g" > $REPO_LIST

    cat $REPO_LIST | \
        while read REPO; do
            getReadmeHTML $DIR $REPO $BRANCH
        done

    INDEX_HTML=$DIR/index_${BRANCH}.html
    mergeAll $DIR $INDEX_HTML;
    rm $REPO_JSON
    open $INDEX_HTML
}

getRepoList $1 $2;
