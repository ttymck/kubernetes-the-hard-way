{

cat > ./certs/kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Los Angeles",
      "O": "system:node-proxier",
      "OU": "Kubernetes The Hard Way",
      "ST": "California"
    }
  ]
}
EOF

cfssl gencert \
  -ca=certs/ca.pem \
  -ca-key=certs/ca-key.pem \
  -config=certs/ca-config.json \
  -profile=kubernetes \
  ./certs/kube-proxy-csr.json | cfssljson -bare ./certs/kube-proxy

}