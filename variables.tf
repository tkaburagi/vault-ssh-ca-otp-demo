variable "ami-version" {
  default = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "ami-owner" {
  default = "099720109477"
}

variable "region" {
  default = "ap-northeast-1"
}

variable "keypair" {
  default = "ssh-keypair"
}

variable "vault_addr" {}

variable "vault_ns" {
  default = "admin"
}