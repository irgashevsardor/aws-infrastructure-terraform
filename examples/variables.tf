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

variable "resources" {
  description = "Object of Resources"
  type = map(object({
    public_subnet_cidr  = string
    private_subnet_cidr = string
  }))

  default = {
    "us-east-1a" = {
      public_subnet_cidr  = "10.0.1.0/24"
      private_subnet_cidr = "10.0.2.0/24"
    }
    "us-east-1b" = {
      public_subnet_cidr  = "10.0.3.0/24"
      private_subnet_cidr = "10.0.4.0/24"
    }
  }
}

variable "rtb_cidr" {
  description = "Route Table CIDR"
  type        = string
  default     = "0.0.0.0/0"
}

variable "environment" {
  description = "Working environment"
  type        = string
  default     = "dev"
}