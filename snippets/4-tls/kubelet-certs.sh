for ix in {0..2}; do
INSTANCE="node-${ix}"
echo ${INSTANCE}
cat > ${INSTANCE}-csr.json <<EOF
{
  "CN": "system:node:${INSTANCE}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Los Angeles",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "California"
    }
  ]
}
EOF

EXTERNAL_IP=$(gcloud compute instances describe ${INSTANCE} \
  --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')

INTERNAL_IP=$(gcloud compute instances describe ${INSTANCE} \
  --format 'value(networkInterfaces[0].networkIP)')

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${INSTANCE},${EXTERNAL_IP},${INTERNAL_IP} \
  -profile=kubernetes \
  ${INSTANCE}-csr.json | cfssljson -bare ${INSTANCE}
done
