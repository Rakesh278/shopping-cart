variable "cidr_block" {}
variable "enable_dns_support" {
  default = true
}
variable "enable_dns_hostnames" {
  default = true
}
variable "tags" {
  type = map(string)
}

variable "azs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}
variable "project_name" {
  description = "Name prefix for resources"
  type        = string
}
