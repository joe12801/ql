#!/bin/bash
systemctl stop wg-quick@wgcf --now 
sleep 3 xrayr restart sleep 3
systemctl restart wg-quick@wgcf --now
