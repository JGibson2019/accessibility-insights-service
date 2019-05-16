#!/bin/bash
set -eo pipefail

# This script will grant permissions to the managed identity to access key vault

# Read script arguments
while getopts "k:i:" option; do
case $option in
    k) keyVault=${OPTARG};;
    i) systemAssignedIdentity=${OPTARG};;
esac
done

if [[ -z $keyVault ]] || [[ -z $systemAssignedIdentity ]]; then
    echo \
"
Usage: $0 -k <key vault> -i <system-assigned managed identity Id>
"
    exit 1
fi

# Grant permissions to the managed identity
echo "Granting '$systemAssignedIdentity' managed identity permissions to '$keyVault' key vault"
az keyvault set-policy --name "$keyVault" --object-id "$systemAssignedIdentity" --secret-permissions get list 1> /dev/null
