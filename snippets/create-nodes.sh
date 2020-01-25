 for i in 0 1 2; do
     gcloud compute instances create node-${i} \
         --async \
         --boot-disk-size 200GB \
         --can-ip-forward \
         --image-family ubuntu-1804-lts \
         --image-project ubuntu-os-cloud \
         --machine-type n1-standard-1 \
         --metadata pod-cidr=10.1.${i}.0/24 \
         --private-network-ip 10.0.2.${i} \
         --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
         --subnet k8s-subnet-1 \
         --tags k8s-thw,node
     done
