variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}

variable "region" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami" {
  type = string
}

variable "ssh_key_path" {
  type = string
  default = ""
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "servers" {
  type = map(map(object({
    static  = optional(bool, false),
    enabled = optional(bool, false),
  })))
  default = {}
}