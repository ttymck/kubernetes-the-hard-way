for ix in {0..2}; do
    instance="master-${ix}"
    instance_ip=$(gcloud compute instances describe ${instance}\
     --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
     echo ${instance_ip}
done