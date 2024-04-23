variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Invalid CIDR block argument"
  }
}

variable "region" {
  description = "VPC region"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.region))
    error_message = "Invalid AWS Region name"
  }
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

  validation {
    condition = alltrue([
      for az, subnet in var.resources :
      can(cidrsubnet(subnet.public_subnet_cidr, 0, 0)) &&
      can(cidrsubnet(subnet.private_subnet_cidr, 0, 0))
    ])
    error_message = "Invalid CIDR block argument"
  }
}

variable "rtb_cidr" {
  description = "Route Table CIDR"
  type        = string
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrhost(var.rtb_cidr, 0))
    error_message = "Invalid CIDR block argument"
  }
}

variable "environment" {
  description = "Working environment"
  type        = string
  default     = "dev"
}
