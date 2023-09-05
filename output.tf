output "otp_host_ip" {
  value = aws_instance.ssh_password_instance.public_ip
}

output "ca_host_ip" {
  value = aws_instance.ssh_pubkey_instance.public_ip
}

output "otp-demo-command" {
  value = [
    "vault write ${vault_mount.ssh_otp.path}/creds/${vault_ssh_secret_backend_role.otp.name} ip=${aws_instance.ssh_password_instance.public_ip}",
    "ssh ubuntu@${aws_instance.ssh_password_instance.public_ip}"
    ]
}

output "ca-demo-command" {
  value = [
    "vault write -field=signed_key ${vault_mount.ssh_ca.path}/sign/${vault_ssh_secret_backend_role.ca.name} public_key=@ssh-vault-demo.pub > signed-cert.pub",
    "ssh -i signed-cert.pub -i ssh-vault-demo  ubuntu@${aws_instance.ssh_pubkey_instance.public_ip}"
  ]
}