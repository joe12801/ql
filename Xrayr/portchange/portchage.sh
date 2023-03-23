#!/bin/bash

# Set the configuration file path
#config_file="/etc/nginx/nginx.conf"

# Get the current port from the configuration file
current_port=$(grep -Eo "listen\s+[0-9]+(\s|$)" /etc/nginx/nginx.conf | awk '{print $2}')

# Check if the port is being used
if lsof -Pi :"$current_port" -sTCP:LISTEN -t >/dev/null ; then
    echo "Port $current_port is open and available."
else
    echo "Port $current_port is closed or being used by another process."
   # Generate a random port between 30000 and 65535
    new_port=$(shuf -i 30000-65535 -n 1)
    # Replace the port in the configuration file using sed
	
sed -i "s/listen\s*${current_port}\s*ssl;/listen ${new_port} ssl;/g" /etc/nginx/nginx.conf
 echo "The port has been changed to $new_port in the configuration file."
fi




