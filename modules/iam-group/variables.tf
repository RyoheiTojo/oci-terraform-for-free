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

variable "membership_ids" {
  type = map(list(string)) # {groupA: ['<userA OCID>', '<userB OCID>']}
  description = "Groupname and userids mappings"
  default     = {}
}
