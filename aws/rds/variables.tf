variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}

variable "region" {
  type = string
}

variable "env" {
  type = string
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "instance_class" {
  type = string
}

variable "databases" {
  type = map(object({
    enabled           = optional(bool, false),
    name              = optional(string, ""),
    engine            = optional(string, ""),
    engine_version    = optional(string, ""),
    allocated_storage = optional(string, ""),
  }))
  default = {}
}