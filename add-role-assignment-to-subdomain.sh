#!/usr/bin/env bash

# ./add-role-assignment-to-subdomain.sh my.subdomain

basedir="$(dirname "${BASH_SOURCE[0]}")"

export $(grep -v '^#' "$basedir/.env" | xargs)

subdomain="$1"

az login --tenant $AZURE_TENANT

scope="/subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$AZURE_RESOURCE_GROUP/providers/Microsoft.Network/dnszones/jagekrans.dev/A/$subdomain"

az role assignment create --assignee $AZURE_USERNAME --role "DNS Zone Contributor" --scope $scope