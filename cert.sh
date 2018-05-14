#!/bin/bash
echo "Enter server IP for 'server FQDN' field"
openssl req -newkey rsa:2048 -sha256 -nodes -keyout key.pem -x509 -days 3650 -out ca.crt
cat key.pem ca.crt > keyca.pem
