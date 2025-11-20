output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.devops_sg.id
}

output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.devops_server.public_ip
}

output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}

output "latest_ubuntu_ami_name" {
  value = data.aws_ami.latest_ubuntu.name
}

output "ec2_public_dns" {
  description = "Public DNS of EC2 instance"
  value       = aws_instance.devops_server.public_dns
}

output "s3_bucket_name" {
  description = "Name of created S3 bucket"
  value       = aws_s3_bucket.devops_bucket.bucket
}
