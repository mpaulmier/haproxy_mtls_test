This is a test repository, this has no purpose at all but to test ome behavior of haproxy.

AI was used in the making of the conf/tests, please be careful, this should **not** be used as a template.

## Setup

```sh
# First clone this repository
git clone git@github.com:mpaulmier/haproxy_mtls_test.git
cd haproxy_mtls_test

# Create the certificates
cd certs
./setup_certs.sh

# Run the container
cd -
docker compose up -d
```

## Testing

To run the test simply launch `test.sh`

Here is the expected output:

```sh
./test.sh
==> Unprotected route / (no failure expected)
HTTP 200 - SUCCESS
OK: path=/ cert_verified=0
----------------------------------------
==> Protected route /admin with valid cert (expect 200)
HTTP 200 - SUCCESS
OK: path=/admin cert_verified=0
----------------------------------------
==> Protected route /admin (no cert, expect 403)
HTTP 403 - FAILURE
<html><body><h1>403 Forbidden</h1>
Request forbidden by administrative rules.
</body></html>
----------------------------------------
==> Protected route /admin with invalid cert (expect 403)
HTTP 403 - FAILURE
<html><body><h1>403 Forbidden</h1>
Request forbidden by administrative rules.
</body></html>
----------------------------------------
```
