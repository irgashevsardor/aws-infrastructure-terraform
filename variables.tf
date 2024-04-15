variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "region" {
  description = "VPC region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Working environment"
  type        = string
  default     = "dev"
}