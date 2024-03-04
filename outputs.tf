output "dev_public_ip" {
  value = aws_instance.dev_node.public_ip
}

output "dev_private_ip" {
  value = aws_instance.dev_node.private_ip
}

output "dev_id" {
  value = aws_instance.dev_node.id
}