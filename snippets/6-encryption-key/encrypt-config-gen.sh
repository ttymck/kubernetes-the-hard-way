ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

cat > ./cfg/encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF

for ix in {0..2}; do
  instance="master-${ix}"
  gcloud compute scp ./cfg/encryption-config.yaml ${instance}:~/
done