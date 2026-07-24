#!/usr/bin/env bash

set -euo pipefail

echo "========================================="
echo "Validating named.conf"
echo "========================================="

named-checkconf

echo "named.conf validation successful."
