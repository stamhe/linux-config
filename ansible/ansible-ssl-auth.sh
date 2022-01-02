#!/bin/bash

# https://certbot.eff.org/docs/using.html#renewing-certificates
#CERTBOT_DOMAIN: The domain being authenticated
#CERTBOT_VALIDATION: The validation string
#CERTBOT_TOKEN: Resource name part of the HTTP-01 challenge (HTTP-01 only)
#CERTBOT_REMAINING_CHALLENGES: Number of challenges remaining after the current challenge
#CERTBOT_ALL_DOMAINS: A comma-separated list of all domains challenged for the current certificate
#CERTBOT_AUTH_OUTPUT: contains the stdout output from the auth script
domain_dir=/data/www/common
domain_name="${CERTBOT_DOMAIN}"
log_name=/data/logs/ssl_apply.log
DATE=`date +%Y-%m-%d" "%H:%M:%S`

# 保证变量不为空才删除文件夹，防止误删除 / 根目录
if [ ${domain_dir}"X" != "X" ] ; then
	rm -fr ${domain_dir}
fi 
mkdir -p ${domain_dir}/.well-known/acme-challenge > /dev/null 2>&1 
echo $CERTBOT_VALIDATION > ${domain_dir}/.well-known/acme-challenge/$CERTBOT_TOKEN


# 第一次清空日志
echo $DATE > ${log_name}
echo "start rsync verify to ${target_host}" >> ${log_name}
rsync -cavPt -e 'ssh -i /data/ssh/id_rsa' ${domain_dir}/  root@${domain_name}:${domain_dir}/ >> ${log_name}
if [ $? -eq 0 ] ; then
echo "fail to rsync verify to ${target_host}" >> ${log_name}
else
echo "success to rsync verify to ${target_host}" >> ${log_name}
fi
