variable "host_os" {
  type        = string
  default     = "linux"
  description = "host os"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.123.0.0/16" 
  description = "cidr block for VPC"
}

variable "subnet_cidr" {
  type        = string
  default     = "10.123.1.0/24"
  description = "cidr block for subnet"
}

variable "subnet_az" {
  type        = string
  default     = "us-east-1a"
  description = "availibility zone of subnet"
}

# This allows anyone to access. Replace "0.0.0.0/0" with a list of allowed IPs in actual use
variable "sg_ingress_cidrs" {
  type        = list
  default     = ["0.0.0.0/0"]
  description = "whitelisted ips for ingress"
}