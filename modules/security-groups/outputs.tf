output "public-instance-sg-id" {
  value = aws_security_group.public-instance-sg.id
}

output "private-instance-sg-id" {
  value = aws_security_group.private-instance-sg.id
}