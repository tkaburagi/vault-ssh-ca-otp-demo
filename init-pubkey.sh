#!/bin/bash
sudo curl \
  -H "X-Vault-Namespace: ${vault_ns}" \
  ${vault_addr}/v1/${ssh_otp_path}/public_key | sudo tee /etc/ssh/trusted-user-ca-keys.pem
sudo sed -i '$a TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem' /etc/ssh/sshd_config
sudo service sshd restart