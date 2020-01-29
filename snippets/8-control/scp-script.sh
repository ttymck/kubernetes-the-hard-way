for ix in {0..2}; do
  instance="master-${ix}"
  gcloud compute scp ./snippets/8-control/bootstrap-controller.sh ${instance}:~/
done