resource "vault_mount" "ssh_otp" {
  type = "ssh"
  path = "ssh-otp"
}

resource "vault_mount" "ssh_ca" {
  type = "ssh"
  path = "ssh-ca"
}

resource "vault_ssh_secret_backend_role" "otp" {
  name              = "otp-role"
  backend           = vault_mount.ssh_otp.path
  key_type          = "otp"
  default_user      = "ubuntu"
  cidr_list         = "0.0.0.0/0"
}

resource "vault_ssh_secret_backend_ca" "ca" {
  backend              = vault_mount.ssh_ca.path
  generate_signing_key = true
}

resource "vault_ssh_secret_backend_role" "ca" {
  name                    = "pubkey-role"
  backend                 = vault_mount.ssh_ca.path
  key_type                = "ca"
  allow_user_certificates = true
  default_user            = "ubuntu"
  ttl                     = "1m"
  max_ttl                 = "30m"
  allowed_users           = "ubuntu"
  default_extensions = {
    "permit-pty" : ""
  }
}