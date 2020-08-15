openssl genrsa -out ets-key.pem 2048
openssl req -new -sha256 -key ets-key.pem -out ets-csr.pem
openssl x509 -req -in ets-csr.pem -signkey ets-key.pem -out ets-cert.pem