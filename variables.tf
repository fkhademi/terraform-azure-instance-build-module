variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "rg" {
  type = string
}

variable "vnet" {
  type = string
}

variable "subnet" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "cloud_init_data" {
  type = string
}

variable "instance_size" {
  type    = string
  default = "Standard_B1ms"
}

variable "public_ip" {
  type    = bool
  default = false
}