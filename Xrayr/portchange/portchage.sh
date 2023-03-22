#!/bin/bash

# Set the configuration file path
config_file="/etc/nginx/nginx.conf"

# Get the current port from the configuration file
current_port=$(grep -oP '(?<=listen\s)[0-9]+' "$config_file")

# Check if the port is being used
if lsof -Pi :"$current_port" -sTCP:LISTEN -t >/dev/null ; then
    echo "Port $current_port is open and available."
else
    echo "Port $current_port is closed or being used by another process."

    # Generate a random port between 30000 and 65535
    new_port=$(shuf -i 30000-65535 -n 1)

    # Replace the port in the configuration file using sed
    sed -i -E "s/(listen\s+)[0-9]+(\s+ssl;)/\1${new_port}\2/" "$config_file"

    echo "The port has been changed to $new_port in the configuration file."
fi
