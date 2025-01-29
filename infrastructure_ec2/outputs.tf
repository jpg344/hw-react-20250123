output "ec2_public_ip" {
  value = aws_instance.react_ec2.public_ip
}