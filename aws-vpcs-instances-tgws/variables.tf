variable "vpc1_subnet_config" {
  type = map(object({
    cidr_block = string
    availability_zone = string
  }))
  default = {
    "vpc1_subnet1" = { cidr_block = "10.1.0.0/24", availability_zone = "us-east-1a" }
    "vpc1_subnet2" = { cidr_block = "10.1.1.0/24", availability_zone = "us-east-1b" }
  }
}

variable "vpc2_east1_subnet_cidrs" {
  type = list(string)
  default = ["10.2.0.0/24", "10.2.1.0/24"]
}

variable "vpc1_east2_subnet_cidrs" {
  type = list(string)
  default = ["10.3.0.0/24", "10.3.1.0/24", "10.3.2.0/24"]
}
