output "ec2_public_ip_address" {
  value = aws_instance.my_ec2_instance.public_ip
}

output "ec2_private_ip_address" {
  value = aws_instance.my_ec2_instance.private_ip
}

output "ec2_pem" {
  value = aws_instance.my_ec2_instance.key_name
}