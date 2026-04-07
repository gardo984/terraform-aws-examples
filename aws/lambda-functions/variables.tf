variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}

variable "region" {
  type = string
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "lambdas" {
  type = map(object({
    name    = optional(string, "")
    enabled = optional(bool, false)
    handler    = optional(string, "")
    runtime    = optional(string, "")
  }))
}
