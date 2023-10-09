variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}

variable "subnet1_cidr_block" {
    default = "10.0.0.0/24"
}

variable "subnet2_cidr_block" {
    default = "10.0.1.0/24"
}

variable "worker_instance_type" {
  default = "t3.micro"
}

variable "ssh_public_key" {
    default = "/home/pavlo/.ssh/terraform.pub"
}