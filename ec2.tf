data "aws_ami" "latest_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami-version]
  }

  owners = [var.ami-owner]
}

resource "aws_instance" "ssh_password_instance" {
  ami           = data.aws_ami.latest_ubuntu.image_id
  instance_type = "t2.micro"
  key_name      = var.keypair

  subnet_id                   = aws_subnet.my_subnet.id
  security_groups             = [aws_security_group.ssh_sg.id]
  associate_public_ip_address = true

  user_data = templatefile("init-otp.sh",
    {
      vault_addr   = var.vault_addr
      vault_ns     = var.vault_ns
      ssh_otp_path = vault_mount.ssh_otp.path
    }
  )
  tags = {
    Name = "SSH-Password-Instance"
  }
}

resource "aws_instance" "ssh_pubkey_instance" {
  ami           = data.aws_ami.latest_ubuntu.image_id
  instance_type = "t2.micro"
  key_name      = var.keypair

  subnet_id                   = aws_subnet.my_subnet.id
  security_groups             = [aws_security_group.ssh_sg.id]
  associate_public_ip_address = true

  user_data = templatefile("init-pubkey.sh",
    {
      vault_addr   = var.vault_addr
      vault_ns     = var.vault_ns
      ssh_otp_path = vault_mount.ssh_ca.path
    }
  )
  tags = {
    Name = "SSH-Pubkey-Instance"
  }
}
