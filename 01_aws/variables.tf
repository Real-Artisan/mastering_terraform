variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
  description = "VPC CIDR block"
  type = string
}

variable "web_subnet_cidr" {
  default = "10.0.10.0/24"
  description = "web subnet CIDR block"
  type = string
}
variable "main_vpc_name" {
    
}