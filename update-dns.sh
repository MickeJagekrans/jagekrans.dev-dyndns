#!/usr/bin/env bash

basedir="$(dirname "${BASH_SOURCE[0]}")"

export $(grep -v '^#' "$basedir/.env" | xargs)

current_ip=$(curl https://api.ipify.org/)
certfile="$basedir/$AZURE_CERTFILE"

az login --service-principal -u $AZURE_USERNAME -p $certfile --tenant $AZURE_TENANT

record_sets=($(cat "$basedir/record-sets.txt"))

function check_and_update() {
	local record_set_name=$1

	ip_addr=$(az network dns record-set a show -n $record_set_name -g $AZURE_RESOURCE_GROUP --subscription $AZURE_SUBSCRIPTION_ID -z $AZURE_DNS_ZONE_NAME | jq -r '.ARecords[].ipv4Address')

	if [ -z "$ip_addr" ] || [ "$ip_addr" != "$current_ip" ]; then
		echo "updating $record_set_name with $current_ip"

		az network dns record-set a add-record -g $AZURE_RESOURCE_GROUP -z $AZURE_DNS_ZONE_NAME -n $record_set_name -a $current_ip --ttl 600

		az network dns record-set a remove-record -g $AZURE_RESOURCE_GROUP -z $AZURE_DNS_ZONE_NAME -n $record_set_name -a $ip_addr
	else
		echo "$record_set_name already in sync"
	fi
}

for record_set in "${record_sets[@]}"; do
	check_and_update "$record_set" &
done

wait
