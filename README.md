This is a test repository, this has no purpose at all but to test ome behavior of haproxy.

## Setup

```sh
# first clone this repository
git clone git@github.com:mpaulmier/haproxy_mtls_test.git
cd haproxy_mtls_test

cd certs
./setup.sh

cd -
docker compose up -d
```

To run the test simply launch `test.sh`
