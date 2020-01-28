pushd certs

for ix in {0..2}; do
  instance="node-${ix}"
  gcloud compute scp ca.pem ${instance}-key.pem ${instance}.pem ${instance}:~/
done

for ix in {0..2}; do
  instance="master-${ix}"
  gcloud compute scp ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem \
    service-account-key.pem service-account.pem ${instance}:~/
done

popd