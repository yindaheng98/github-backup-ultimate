#!/bin/bash

#创建仓库并返回仓库clone地址

USER=$1
TOKEN=$2
REPO_NAME=$3
PRIVATE=$4
DESCRIPTION="$5"
HEADER="PRIVATE-TOKEN: $TOKEN"
URL_DATA="--data-urlencode 'description=$DESCRIPTION'"
if [ $PRIVATE='false' ]; then
    URL_DATA=$URL_DATA" --data-urlencode 'visibility=public'"
else
    URL_DATA=$URL_DATA" --data-urlencode 'visibility=private'"
fi

CREATE_URL='https://gitlab.com/api/v4/projects'
CREATE_CMD="curl -X POST --header '$HEADER' -s '$CREATE_URL' $URL_DATA --data-urlencode 'name=$REPO_NAME'"
eval "$CREATE_CMD" | jq . >&2 #新建仓库

MODIFY_URL='https://gitlab.com/api/v4/projects/'$USER'%2F'$REPO_NAME
MODIFY_CMD="curl -X PUT --header '$HEADER' -s '$MODIFY_URL' $URL_DATA"
eval "$MODIFY_CMD" | jq . >&2 #修改已有仓库的private状态

echo 'https://'$USER':'$TOKEN'@gitlab.com/'$USER'/'$REPO_NAME