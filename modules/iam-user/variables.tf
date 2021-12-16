variable "tenancy_ocid" {
  type = string
  description = "The OCID of the tenancy."
  default = null
}

variable users {
  description = "The users in the tenancy."
  type = list(object({
    name        = string
    description = string
    email       = string
  }))
  default = null
}
