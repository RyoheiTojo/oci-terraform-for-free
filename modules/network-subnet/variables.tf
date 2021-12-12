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

variable "subnets" {
  type         = map(object({
    cidr_block       = string,
    display_name     = string,
    is_public        = bool
  }))
  description  = "Parameters for each subnet to be created/managed."
  default      = {
    default_subnet = {
      cidr_block       = null
      display_name     = null
      is_public        = false
    }
  }
}
