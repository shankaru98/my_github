 locals {
    app_port = 80
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "pair_file" {
  key_name = var.key_name
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "pem-key" {
  content = tls_private_key.rsa.private_key_pem
  filename = var.key_path
}

resource "aws_security_group" "allow_ssh" {
  name        = var.sg_name
  description = "Allow SSH inbound traffic"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 ingress {
    from_port        = local.app_port
    to_port          = local.app_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


resource "aws_instance" "my_ec2_instance" {
  ami = var.ami_id
  instance_type = var.ec2_type
  key_name = aws_key_pair.pair_file.key_name
   vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
        Name = "Terraform"
  }
}