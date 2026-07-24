#!/usr/bin/env bash

set -euo pipefail

ZONE_ROOT="groups/bind/zones"

echo "========================================="
echo "Checking SOA Serials"
echo "========================================="

find "${ZONE_ROOT}" -type f -name "*.zone" | while read -r zone_file
do

    serial=$(grep -Eo '[0-9]{10}' "${zone_file}" | head -1)

    if [ -z "${serial:-}" ]
    then
        echo "ERROR: Missing serial in ${zone_file}"
        exit 1
    fi

    date_part="${serial:0:8}"

    if ! date -d "${date_part}" >/dev/null 2>&1
    then
        echo "ERROR: Invalid serial date ${serial}"
        exit 1
    fi

    echo "Valid serial found: ${serial}"
done
