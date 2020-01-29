KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe k8s-ip-1 \
  --region $(gcloud config get-value compute/region) \
  --format 'value(address)')

RESP=$(curl --silent --cacert ./certs/ca.pem https://${KUBERNETES_PUBLIC_ADDRESS}:6443/version)

MAJOR=$(echo "${RESP}" | jq -r .major)
MINOR=$(echo "${RESP}" | jq -r .minor)
COMMIT=$(echo "${RESP}" | jq -r .gitCommit)
DATE=$(echo "${RESP}" | jq -r .buildDate)

echo "v${MAJOR}.${MINOR}-${COMMIT}@${DATE}"