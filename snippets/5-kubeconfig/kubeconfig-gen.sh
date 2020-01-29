PROJ_NAME=k8s-ip-1
KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe $PROJ_NAME \
  --region $(gcloud config get-value compute/region) \
  --format 'value(address)')

# NODE KUBE CONFIGS

for ix in {0..2}; do
  instance="node-${ix}"

  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=./certs/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=./cfg/${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=./certs/${instance}.pem \
    --client-key=./certs/${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=./cfg/${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:${instance} \
    --kubeconfig=./cfg/${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=./cfg/${instance}.kubeconfig
done

## KUBE PROXY
{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=./certs/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=./cfg/kube-proxy.kubeconfig

  kubectl config set-credentials system:kube-proxy \
    --client-certificate=./certs/kube-proxy.pem \
    --client-key=./certs/kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=./cfg/kube-proxy.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-proxy \
    --kubeconfig=./cfg/kube-proxy.kubeconfig

  kubectl config use-context default --kubeconfig=./cfg/kube-proxy.kubeconfig
}

# KUBE CONTROLLER MANAGER CONFIG

{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=./certs/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=./cfg/kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=./certs/kube-controller-manager.pem \
    --client-key=./certs/kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=./cfg/kube-controller-manager.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-controller-manager \
    --kubeconfig=./cfg/kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=./cfg/kube-controller-manager.kubeconfig
}

# KUBE SCHEDULER CONFIG

{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=./certs/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=./cfg/kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler \
    --client-certificate=./certs/kube-scheduler.pem \
    --client-key=./certs/kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=./cfg/kube-scheduler.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-scheduler \
    --kubeconfig=./cfg/kube-scheduler.kubeconfig

  kubectl config use-context default --kubeconfig=./cfg/kube-scheduler.kubeconfig
}

# ADMIN KUBECONFIG

{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=./certs/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=./cfg/admin.kubeconfig

  kubectl config set-credentials admin \
    --client-certificate=./certs/admin.pem \
    --client-key=./certs/admin-key.pem \
    --embed-certs=true \
    --kubeconfig=./cfg/admin.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=admin \
    --kubeconfig=./cfg/admin.kubeconfig

  kubectl config use-context default --kubeconfig=./cfg/admin.kubeconfig
}

# DISTRIBUTE

pushd cfg

for ix in {0..2}; do
  instance="node-${ix}"
  gcloud compute scp ${instance}.kubeconfig kube-proxy.kubeconfig ${instance}:~/
done

for ix in {0..2}; do
  instance="master-${ix}"
  gcloud compute scp admin.kubeconfig\
   kube-controller-manager.kubeconfig kube-scheduler.kubeconfig ${instance}:~/
done

popd