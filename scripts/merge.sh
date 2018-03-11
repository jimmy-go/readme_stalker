#!/bin/bash

HTML_DIR=$1
if [ -z "$HTML_DIR" ]; then
    echo "Html directory not set"
    exit 1
fi
OUT_FILE=$2
if [ -z "$OUT_FILE" ]; then
    echo "Out file not set"
    exit 1
fi

ls -lha $HTML_DIR
ls -lha $HTML_DIR/trash
cat ${HTML_DIR}/*.html > ${OUT_FILE}
