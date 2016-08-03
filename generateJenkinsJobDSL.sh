#!/usr/bin/env bash

if [ -h ${BASH_SOURCE[0]} ]; then
    WORK_DIR=$( cd "$( dirname "`readlink -f ${BASH_SOURCE[0]}`" )" && pwd )
else
    WORK_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
fi

pushd $WORK_DIR &>/dev/null

    TEMPLATE_JOB_FILE='job-templates/multiscreen-job-template.dsl'
    TEMPLATE_SEED_JOB_FILE='job-templates/multiscreen-seed-job-template.xml'
    MULTISCREEN_JOB_DSL_FILE='artifacts/multiscreen-job.dsl'
    MULTISCREEN_SEED_JOB_FILE='artifacts/multiscreen-seed-job.xml'
    rm -f $MULTISCREEN_JOB_DSL_FILE
    mkdir -p artifacts

    for config in $(ls job-configurations); do
        # Load configuration of each job in config
        source "job-configurations/${config}"

        echo "Processing Job Configuration '${config}'"
        #echo "JOB_NAME: ${JOB_NAME//\//\\/}"
        #echo "JOB_DESCRIPTION: ${JOB_DESCRIPTION//\//\\/}"
        #echo "JOB_GIT_URL: ${JOB_GIT_URL//\//\\/}"
        #echo "JOB_NAME_BRANCH: ${JOB_NAME_BRANCH//\//\\/}"
        #echo "JOB_DESCRIPTION_BRANCH: ${JOB_DESCRIPTION_BRANCH//\//\\/}"

        TMP_JOB_FILE="artifacts/${config}"
        cp $TEMPLATE_JOB_FILE $TMP_JOB_FILE
        OS="`uname`"
        # if on a mac - need to change command slightly
        if [ "$OS" == "Darwin" ]; then
            sed -i '' "s/#{JOB_NAME}/${JOB_NAME//\//\\/}/g" $TMP_JOB_FILE
            sed -i '' "s/#{JOB_DESCRIPTION}/${JOB_DESCRIPTION//\//\\/}/g" $TMP_JOB_FILE
            sed -i '' "s/#{JOB_GIT_URL}/${JOB_GIT_URL//\//\\/}/g" $TMP_JOB_FILE
            sed -i '' "s/#{JOB_NAME_BRANCH}/${JOB_NAME_BRANCH//\//\\/}/g" $TMP_JOB_FILE
            sed -i '' "s/#{JOB_DESCRIPTION_BRANCH}/${JOB_DESCRIPTION_BRANCH//\//\\/}/g" $TMP_JOB_FILE

            sed -i '' "s/#{MAJOR}/${MAJOR//\//\\/}/g" $TMP_JOB_FILE
            sed -i '' "s/#{MINOR}/${MINOR//\//\\/}/g" $TMP_JOB_FILE
            sed -i '' "s/#{PATCH}/${PATCH//\//\\/}/g" $TMP_JOB_FILE
        else
            sed -i "s/#{JOB_NAME}/${JOB_NAME//\//\\/}/g" $TMP_JOB_FILE
            sed -i "s/#{JOB_DESCRIPTION}/${JOB_DESCRIPTION//\//\\/}/g" $TMP_JOB_FILE
            sed -i "s/#{JOB_GIT_URL}/${JOB_GIT_URL//\//\\/}/g" $TMP_JOB_FILE
            sed -i "s/#{JOB_NAME_BRANCH}/${JOB_NAME_BRANCH//\//\\/}/g" $TMP_JOB_FILE
            sed -i "s/#{JOB_DESCRIPTION_BRANCH}/${JOB_DESCRIPTION_BRANCH//\//\\/}/g" $TMP_JOB_FILE

            sed -i "s/#{MAJOR}/${MAJOR//\//\\/}/g" $TMP_JOB_FILE
            sed -i "s/#{MINOR}/${MINOR//\//\\/}/g" $TMP_JOB_FILE
            sed -i "s/#{PATCH}/${PATCH//\//\\/}/g" $TMP_JOB_FILE
        fi

        cat $TMP_JOB_FILE >> $MULTISCREEN_JOB_DSL_FILE
        echo "" >> $MULTISCREEN_JOB_DSL_FILE
        rm $TMP_JOB_FILE
    done

    sed "/#{JOB_DSL}/{
    s/#{JOB_DSL}//g
    r $MULTISCREEN_JOB_DSL_FILE
    }" $TEMPLATE_SEED_JOB_FILE > $MULTISCREEN_SEED_JOB_FILE

popd &>/dev/null