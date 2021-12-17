variable "tenancy_ocid" {
  type = string
  description = "The OCID of the tenancy."
  default = null
}

variable "groups" {
  type = map(object({
    description         = string,
    compartment_name    = string,
    statements_tpl_path = string,
  }))
  description = "Groups definitions"
  default = null
}

variable "user_ids" {
  type = list(string)
  description = "List of user ocids to be added as group member"
  default     = null
}
