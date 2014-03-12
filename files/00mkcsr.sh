#!/bin/sh

CERTPASS="qwer1234"
CONFFILE="/etc/puppet/modules/ssl/files/00openssl.cnf"
export SSL_HOSTNAME=$1

echo "Private Key           = ${SSL_HOSTNAME}.pkey"
echo "Private Key (No Pass) = ${SSL_HOSTNAME}.key"
echo "CSR                   = ${SSL_HOSTNAME}.csr"

openssl genrsa -des3 -passout pass:${CERTPASS} -out "${SSL_HOSTNAME}.pkey" 2048
openssl req -config ${CONFFILE} -sha1 -batch -new -passin pass:${CERTPASS} -key "${SSL_HOSTNAME}.pkey" -out "${SSL_HOSTNAME}.csr"
openssl rsa -passin pass:${CERTPASS} -in "${SSL_HOSTNAME}.pkey" -out "${SSL_HOSTNAME}.key"
cat ${SSL_HOSTNAME}.csr
