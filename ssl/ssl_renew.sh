#!/bin/bash
# certbot certificates

domain_list="www.google.com"

for domain in $domain_list
do
    #certbot certonly --manual --manual-public-ip-logging-ok --manual-auth-hook /data/ssl_authorize.sh -d "$domain" --dry-run 
    certbot certonly --manual --keep-until-expiring --manual-public-ip-logging-ok --manual-auth-hook /data/ssl_authorize.sh -d "$domain"
done

