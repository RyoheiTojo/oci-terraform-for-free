variable "tenancy_ocid" {
  type = string
  description = "The OCID of the tenancy."
  default = null
}

variable "dynamic_groups" {
  type = map(object({
    compartment_name    = string,
    description         = string,
    matching_rule       = string,
    statements_tpl_path = string,
  }))
  description = "Dynamic definitions"
  default = {
    default_group = {
      compartment_name    = null
      description         = null
      matching_rule       = null
      statements_tpl_path = null
    }
  }
}
