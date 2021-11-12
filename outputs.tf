output "ec2_address" {
  value = [aws_instance.instance.*.public_ip, aws_instance.instance.public_dns]
}
