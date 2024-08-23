#!/bin/bash
(crontab -l ; echo "30 3 * * * /usr/local/cert/update_cert.sh") | crontab -
