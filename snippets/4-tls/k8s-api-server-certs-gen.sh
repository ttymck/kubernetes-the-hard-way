{

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe k8s-thw \
  --region $(gcloud config get-value compute/region) \
  --format 'value(address)')

KUBERNETES_HOSTNAMES=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local

cat > ./certs/kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
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
  -ca=certs/ca.pem \
  -ca-key=certs/ca-key.pem \
  -config=certs/ca-config.json \
  -hostname=10.32.0.1,10.240.0.10,10.240.0.11,10.240.0.12,${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,${KUBERNETES_HOSTNAMES} \
  -profile=kubernetes \
  ./certs/kubernetes-csr.json | cfssljson -bare ./certs/kubernetes

}