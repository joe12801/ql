#!/bin/bash
config_xrayr="/etc/XrayR/config.yml"
# Use grep to find the line with NodeID and extract the port number
node=$(grep "NodeID:" $config_xrayr | grep -oE '[0-9]+')
# Print the port number
echo "$node"
