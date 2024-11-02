# Azure DNS Zone Management Scripts

This repository contains scripts for managing DNS records and role assignments in Azure.

## Scripts

- `update-dns.sh`: Updates DNS records with the current public IP address.
- `add-role-assignment-to-subdomain.sh`: Adds a role assignment to a subdomain in Azure.

## Setup

### Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- A service principal with the necessary permissions to manage DNS records in Azure.
- `jq` installed for JSON parsing.

### Environment Variables

Create a `.env` file in the same directory as the scripts with the following content:

```env
AZURE_USERNAME=your-azure-username
AZURE_CERTFILE=path-to-your-certfile.pem (relative to the script file)
AZURE_TENANT=your-tenant-id
AZURE_SUBSCRIPTION_ID=your-subscription-id
AZURE_RESOURCE_GROUP=your-resource-group
AZURE_DNS_ZONE_NAME=your-dns-zone-name
```

You can also expose the env vars without an .env file.

## Record Sets

Create a record-sets.txt file in the same directory as the scripts with the DNS record sets you want to manage:

```
subdomain.a
subdomain2.a
other
```

## Usage 

### update-dns.sh

The `update-dns.sh` script updates the DNS records with the current public IP address of the machine where it runs. It's designed to be run as a cron job but can be run manually.

#### Running manually

```
source /path/to/.env && /path/to/update-dns.sh
```

#### Cron Job

To run the script as a cron job, edit your crontab:

```
crontab -e
```

Add the following line to run the script every fifteen minutes:

```
*/15 * * * * source /path/to/.env && /path/to/update-dns.sh &>> /path/to/update-dns.log
```

### add-role-assignment-to-subdomain.sh

The `add-role-assignment-to-subdomain.sh` script adds a role assignment to a subdomain in Azure. This script should be called after adding a DNS zone entry manually to allow the Azure user to update the entry.

#### Running the script

```
source /path/to/.env && ./add-role-assignment-to-subdomain.sh some.subdomain
```

