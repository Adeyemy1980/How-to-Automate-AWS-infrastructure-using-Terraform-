variable "dev_vpc" {
    default = "10.0.0.0/16"
    type = string
    description = "VPC cidr block"
  
}

variable "subnet" {
    default = "10.0.0.0/24"
    type = string
    description = "subnet cidr block"
  
}

variable "my-ip" {
    default = "49.187.54.166/32"
    description = "This is my IP address"
    type = string
  }

variable "availability_zone" {
    default = "us-east-1a"
  
}

variable "public_key_location" {
    default = "C:/Users/eniad/.ssh/id_rsa.pub"
    }

  