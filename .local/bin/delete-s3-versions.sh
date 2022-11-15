#!/bin/bash

bucket=$1
prefix=$2
date=${3:-$(date +"%Y-%m-%d" --date='tomorrow')}
endpoint="https://s3.fr-par.scw.cloud"

objects=$(aws --endpoint-url "$endpoint" s3api list-object-versions --bucket "$bucket" --prefix "$prefix")
data=$(echo "$objects" | jq ".Versions | sort_by(.Size) | reverse | .[] | select(.LastModified < \"$date\") | {VersionId, Key}")

for row in $(echo "$data" | jq -s '.' | jq -r '.[] | @base64'); do
    key=$(echo "$row" | base64 --decode | jq -r ".Key")
    id=$(echo "$row" | base64 --decode | jq -r ".VersionId")

    echo "Delete $key ($id)"
    aws --endpoint-url "$endpoint" s3api delete-object --bucket "$bucket" --key "$key" --version-id "$id"
done
