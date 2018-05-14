#!/bin/bash

HOST=git@lehdari.fi

ARGUMENTS="$@"
PROJECT_NAME=""

while [ $# -gt 0 ]; do
    if [ $1 == "-p" ]; then
        PROJECT_NAME=$2
    fi
    shift
done

if [ -z ${PROJECT_NAME} ]; then
    echo "Error: Please provide a project name"
    exit 1
fi


ssh ${HOST} << EOF
    cd git/templates/
    ./create_from_template.sh -p ${PROJECT_NAME} -d ..
EOF

git clone ${HOST}:~/git/${PROJECT_NAME}.git
