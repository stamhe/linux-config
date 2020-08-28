#!/bin/bash

# https://certbot.eff.org/docs/using.html#renewing-certificates
#CERTBOT_DOMAIN: The domain being authenticated
#CERTBOT_VALIDATION: The validation string
#CERTBOT_TOKEN: Resource name part of the HTTP-01 challenge (HTTP-01 only)
#CERTBOT_REMAINING_CHALLENGES: Number of challenges remaining after the current challenge
#CERTBOT_ALL_DOMAINS: A comma-separated list of all domains challenged for the current certificate
mkdir -p /data/www/common/.well-known/acme-challenge > /dev/null 2>&1 
echo $CERTBOT_VALIDATION > /data/www/common/.well-known/acme-challenge/$CERTBOT_TOKEN
