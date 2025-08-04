variable "region" {
  type    = string
  default = "ap-south-1" 
}

variable "project_name" {
  default = "shopping-cart"
}
variable "key_pair_name" {}
variable "instance_type" {
  default = "t3.medium"
}
variable "vpc_id" {
  description = "The ID of the VPC where resources will be deployed"
  type        = string
}
variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}