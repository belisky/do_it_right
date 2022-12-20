
variable "az" {
  description = "AZs in this region to use"
  default     = ["us-east-1a", "us-east-1b"]
  type        = list(any)
}
variable "instance_tenancy" {
  default = "default"
}

variable "sn_cidrs_block" {
  description = "Subnet CIDRs for public subnets (length must match configured availability_zones)"
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
  type        = list(any)
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "test"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block  = "0.1.0.0/0"
      description = "test"
    },
  ]
}

variable "ami" {
  default = "ami-0574da719dca65348"
}

variable "instance_type" {
  default = "t2.micro"
}

#Module vars

variable "tags" {
  type = object({
    Owner           = string
    expiration_date = string
    bootcamp        = string
    managed_by      = string
  })
  default = {
    Owner           = "nobel"
    expiration_date = "01-29-2022"
    bootcamp        = "ghana1"
    managed_by      = "terraform"
  }
}

variable "vpc_cidr" {
  default = "10.1.0.0/16"
}

variable "name" {
  default = "lb"
}
variable "internal" {
  default = true
}
variable "lb_type" {
  default = "application"
}

variable "port" {
  default = 80
}

variable "cidr_block" {
  default = "0.0.0.0/0"
}

variable "az" {
  default = ["us-east-1a", "us-east-1b"]
  type    = list(any)
}
variable "sn_cidr_block" {
  default = ["10.1.0.0/24", "10.1.1.0/24"]
  type    = list(any)
}
variable "auto_ip_assign" {
  default = true
}


variable "tg_name" {
  default = "ws"
}

variable "protocol" {
  default = "HTTP"
}














 