variable "tenancy_ocid" {
  type = string
  description = "The OCID of the tenancy."
  default = null
}

variable users {
  description = "The users in the tenancy."
  type = map(object({
    description = string
    email       = string
  }))
  default = {}
}
