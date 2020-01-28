{

cat > ./certs/kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Los Angeles",
      "O": "system:kube-scheduler",
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
  ./certs/kube-scheduler-csr.json | cfssljson -bare ./certs/kube-scheduler

}