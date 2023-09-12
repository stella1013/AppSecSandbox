output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app-server-jenkins.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app-server-jenkins.public_ip
}
