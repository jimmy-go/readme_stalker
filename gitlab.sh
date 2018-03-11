#!/bin/bash

userGroups() {
    SEP="full_path"
    TOKEN=$1
    GS=$(echo | curl -s https://gitlab.com/api/v4/groups?private_token=$TOKEN)
    JSON=$(echo "$GS" | python -m json.tool)
    echo "$JSON" | grep "$SEP" | sed "s/[ :,\"]//g;s/${SEP}//g"
}

userRepos() {
    SEP='"self"'
    GROUP_SEP='http:\/\/gitlab.com\/api\/v4\/projects'
    TOKEN=$2
    USR=$1
    REPOS=$(echo | curl -s https://gitlab.com/api/v4/users/${USR}/projects?private_token=${TOKEN})
    JSON=$(echo "$REPOS" | python -m json.tool)
    REPID_ARR=$(echo "$JSON" | grep $SEP | sed "s/${GROUP_SEP}//g;s/${SEP}//g;s/[ :,\"/]//g")
    echo $REPID_ARR
}

groupRepos() {
    GROUP=$1
    if [ -z "$GROUP" ]; then
        echo "GROUP not set, skip"
        return
    fi

    TOKEN=$2
    if [ -z "$TOKEN" ]; then
        echo "TOKEN not set, skip"
        return
    fi

    SEP='"self"'
    GROUP_SEP='http:\/\/gitlab.com\/api\/v4\/projects'
    REPOS=$(echo | curl -s https://gitlab.com/api/v4/groups/${GROUP}/projects?private_token=${TOKEN})
    JSON=$(echo "$REPOS" | python -m json.tool)
    REPID_ARR=$(echo "$JSON" | grep "$SEP" | sed "s/${GROUP_SEP}//g;s/${SEP}//g;s/[ :,\"/]//g")
    echo $REPID_ARR
}

getReadme() {
    MD_DIR=$1
    if [ -z "$MD_DIR" ]; then
        echo "MD_DIR not set, skip"
        return
    fi
    ID=$2
    if [ -z "$ID" ]; then
        echo "ID not set, skip"
        return
    fi
    TOKEN=$3
    if [ -z "$TOKEN" ]; then
        echo "TOKEN not set, skip"
        return
    fi
    BRANCH=$4
    if [ -z "$BRANCH" ]; then
        echo "BRANCH not set, skip"
        return
    fi

    NAME=$(projectName $ID $TOKEN)
    FILE="$MD_DIR/${NAME}_${ID}.md"
    URI="https://gitlab.com/api/v4/projects/${ID}/repository/files/README.md/raw?ref=${BRANCH}&private_token=${TOKEN}"
    curl -s -o $FILE $URI
}

projectName() {
    ID=$1
    if [ -z "$ID" ]; then
        echo "ID not set, skip"
        return
    fi
    TOKEN=$2
    if [ -z "$TOKEN" ]; then
        echo "TOKEN not set, skip"
        return
    fi

    URI="https://gitlab.com/api/v4/projects/${ID}?private_token=${TOKEN}"
    PROY=$(echo | curl -s $URI)
    JSON=$(echo "$PROY" | python -m json.tool)
    SEP="path_with_namespace"
    REPNAME=$(echo "$JSON" | grep $SEP | sed "s/${SEP}//g;s/[ :,\"]//g;s/\//_/g")
    echo $REPNAME
}

convertMarkdown() {
    MD_DIR=$1
    if [ -z "$MD_DIR" ]; then
        echo "MD_DIR not set, skip"
        return
    fi
    HTML_DIR=$2
    if [ -z "$HTML_DIR" ]; then
        echo "HTML_DIR not set, skip"
        return
    fi

    IDD=$3
    if [ -z "$IDD" ]; then
        echo "IDD not set, skip"
        return
    fi

    TOKEN=$4
    if [ -z "$TOKEN" ]; then
        echo "TOKEN not set, skip"
        return
    fi

    NAME=$(projectName $IDD $TOKEN)
    FILE=$HTML_DIR/${NAME}_${IDD}.html
    grip --export ${MD_DIR}/${NAME}_${IDD}.md $FILE
}

mergeAll() {
    HTML_DIR=$1
    OUT=$2
    cat ${HTML_DIR}/*.html > ${OUT}
}

allRepos() {
    USR=$1
    BRANCH=$2
    TOKEN=$3
    DIR=gitlab/$USR
    mkdir -p $DIR
    mkdir -p $DIR/markdown
    mkdir -p $DIR/html

    GROUP_LIST=${DIR}/${USR}_groups.list.txt
    REPO_LIST=${DIR}/${USR}_repos.list.txt

    echo $(userRepos $USR $TOKEN) | tr ' ' '\n' > $REPO_LIST

    userGroups $TOKEN > $GROUP_LIST
    cat $GROUP_LIST | \
        while read GR; do
            echo $(groupRepos $GR $TOKEN) | tr ' ' '\n' >> $REPO_LIST
        done
    cat $REPO_LIST | \
        while read REPO_ID; do
            getReadme "$DIR/markdown" ${REPO_ID} ${TOKEN} ${BRANCH}
            convertMarkdown "$DIR/markdown" "$DIR/html" $REPO_ID $TOKEN
        done

    INDEX_HTML="$DIR/index_${BRANCH}.html"
    mergeAll "$DIR/html" $INDEX_HTML
    open $INDEX_HTML
}

allRepos $1 $2 $3;
