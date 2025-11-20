variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key name uploaded to AWS"
  type        = string
  default     = "mainkeys"
}

variable "allow_ports" {
  description = "Ports list"
  type        = list(any)
  default     = ["80", "8080", "443"]
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(any)
  default = {
    Owner   = "Andrew Nazaruk"
    Project = "Secret"
  }

}
