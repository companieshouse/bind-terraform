#!/usr/bin/env bash

set -euo pipefail

ZONE_ROOT="groups/bind/zones"

echo "========================================="
echo "Validating DNS Zone Files"
echo "========================================="

failed=0

find "${ZONE_ROOT}" -type f -name "*.zone" | while read -r zone_file
do
    zone_name=$(basename "${zone_file}" .zone)

    echo ""
    echo "Checking zone: ${zone_name}"
    echo "File: ${zone_file}"

    if ! named-checkzone "${zone_name}" "${zone_file}"
    then
        echo "ERROR: Validation failed for ${zone_file}"
        failed=1
    fi
done

if [ "${failed}" -ne 0 ]
then
    exit 1
fi

echo ""
echo "All zones validated successfully."
