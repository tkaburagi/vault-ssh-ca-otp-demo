#!/bin/bash
sudo apt -y install unzip
curl https://releases.hashicorp.com/vault-ssh-helper/0.2.1/vault-ssh-helper_0.2.1_linux_amd64.zip -o helper.zip
sudo unzip -q helper.zip -d /usr/local/bin
sudo chmod 0755 /usr/local/bin/vault-ssh-helper
sudo chown root:root /usr/local/bin/vault-ssh-helper
sudo mkdir /etc/vault-ssh-helper.d

sudo tee /etc/vault-ssh-helper.d/config.hcl <<EOF
vault_addr = "${vault_addr}"
ssh_mount_point = "${ssh_otp_path}"
allowed_roles = "*"
namespace = "${vault_ns}"
allowed_cidr_list = "0.0.0.0/0"
EOF

sudo sed -i -e "5i auth requisite pam_exec.so quiet expose_authtok log=/tmp/vaultssh.log /usr/local/bin/vault-ssh-helper -config=/etc/vault-ssh-helper.d/config.hcl" /etc/pam.d/sshd
sudo sed -i -e "6i auth optional pam_unix.so not_set_pass use_first_pass nodelay" /etc/pam.d/sshd
sudo sed -i 's/@include common-auth/# @include common-auth/' /etc/pam.d/sshd
sudo sed -i 's/KbdInteractiveAuthentication no/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config

sudo service ssh restart

sudo vault-ssh-helper -verify-only -config /etc/vault-ssh-helper.d/config.hcl