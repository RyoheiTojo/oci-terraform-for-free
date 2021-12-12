variable "tenancy_ocid" {
  type = string
  description = "The tenancy OCID"
  default = null
}

variable "compartment_name" {
  type = string
  description = "Target compartment name"
  default = null
}

variable "vcn_name" {
  type = string
  description = "Target vcn name"
  default = null
}

variable "network_security_groups" {
  type         = map(object({
    display_name     = string
  }))
  description  = "Parameters for each nsg to be created/managed."
  default      = {
    default_subnet = {
      display_name     = null
    }
  }
}
