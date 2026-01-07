#!/bin/sh

# CA
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -subj "/CN=Test CA" -days 365 -out ca.crt

# Server cert
openssl genrsa -out server.key 2048
openssl req -new -key server.key -subj "/CN=localhost" -out server.csr
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365

# Client cert
openssl genrsa -out client.key 2048
openssl req -new -key client.key -subj "/CN=test-client" -out client.csr
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 365

# HAProxy wants cert+key combined
cat server.crt server.key > server.pem
cat client.crt server.crt ca.crt > ca_full.crt

# CA
openssl genrsa -out bad_ca.key 2048
openssl req -x509 -new -nodes -key bad_ca.key -subj "/CN=BadTest CA" -days 365 -out bad_ca.crt

# Server cert
openssl genrsa -out bad_server.key 2048
openssl req -new -key bad_server.key -subj "/CN=bad-localhost" -out bad_server.csr
openssl x509 -req -in bad_server.csr -CA bad_ca.crt -CAkey bad_ca.key -CAcreateserial -out bad_server.crt -days 365

# Client cert
openssl genrsa -out bad_client.key 2048
openssl req -new -key bad_client.key -subj "/CN=bad-test-client" -out bad_client.csr
openssl x509 -req -in bad_client.csr -CA bad_ca.crt -CAkey bad_ca.key -CAcreateserial -out bad_client.crt -days 365

# HAProxy wants cert+key combined
cat bad_server.crt bad_server.key > bad_server.pem
cat bad_client.crt bad_server.crt bad_ca.crt > bad_ca_full.crt
