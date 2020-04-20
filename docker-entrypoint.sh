#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /beesmart/tmp/pids/server.pid

# Exec CDM inside Dockerfile.
exec "$@"
