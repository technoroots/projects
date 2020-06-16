output "pub_ip" {
  value = aws_instance.pub1.public_ip
}

output "private_ip" {
  value = aws_instance.prv1.private_ip
}

