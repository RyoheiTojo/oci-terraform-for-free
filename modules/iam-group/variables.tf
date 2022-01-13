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
  type = map(string)
  description = "Map of user OCID."
  default = {}
}

variable "membership" {
  type = map(list(string)) # {groupA: ['<userA>', '<userB>']}
  description = "Groupname and username mappings"
  default     = {}
}
