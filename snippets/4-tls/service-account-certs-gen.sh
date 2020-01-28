{

cat > ./certs/service-account-csr.json <<EOF
{
  "CN": "service-accounts",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Los Angeles",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "California"
    }
  ]
}
EOF

cfssl gencert \
  -ca=./certs/ca.pem \
  -ca-key=./certs/ca-key.pem \
  -config=./certs/ca-config.json \
  -profile=kubernetes \
  ./certs/service-account-csr.json | cfssljson -bare ./certs/service-account

}