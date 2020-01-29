for ix in {0..2}; do
  instance="node-${ix}"
  gcloud compute scp ./snippets/9-nodes/provision.sh ${instance}:~/
done