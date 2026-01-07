#!/bin/sh

echo "Testing unprotected route / (no failure expected)"
curl -k -i https://localhost:8443/
echo "===="
echo "Testing protected route /admin (failure expected)"
curl -k -i https://localhost:8443/admin
