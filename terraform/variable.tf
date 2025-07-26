variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}
variable "aws_region" {
  description = "AWS region for the resources"
  type        = string
}
variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}
variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}
variable "vpc_security_group_ids" {
  description = "VPC security group IDs for the EC2 instance"
  type        = list(string)
}
variable "key_name" {
  description = "Key pair name for the EC2 instance"
  type        = string
}
variable "volume_size" {
  description = "Volume size for the EC2 instance in GB"
  type        = number
}
variable "volume_type" {
  description = "Volume type for the EC2 instance"
  type        = string
  validation {
    condition     = var.volume_type == "gp2" || var.volume_type == "io1"
    error_message = "Volume type must be either 'gp2' or 'io1'."
  }
}
variable "environment" {
  type        = string
}