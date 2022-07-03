#!/bin/bash
# Opens a remote IEx session to a production fly.io install
# Pilfered from here https://fly.io/docs/app-guides/elixir-observer-connection-to-your-app/

set -e

if [ -z "$COOKIE" ]; then
    echo "Set the COOKIE your project uses in the COOKIE ENV value before running this script"
    exit 1
fi

# Get the first IPv6 address returned
ip_array=( $(fly ips private | awk '(NR>1){ print $3 }') )
IP=${ip_array[0]}

# Get the Fly app name. Assumes it is used as part of the full node name
APP_NAME=`fly info --name`
FULL_NODE_NAME="${APP_NAME}@${IP}"
echo Attempting to connect to $FULL_NODE_NAME

# Export the BEAM settings for running the "iex" command.
# This creates a local node named "my_remote". The name used isn't important.
# The cookie must match the cookie used in your project so the two nodes can connect.
iex --erl "-proto_dist inet6_tcp" --sname my_remote --cookie ${COOKIE}

