{

cat > ./certs/kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Los Angeles",
      "O": "system:kube-controller-manager",
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
  ./certs/kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager

}
