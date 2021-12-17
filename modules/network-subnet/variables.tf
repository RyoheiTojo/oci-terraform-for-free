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
    is_public        = bool
  }))
  description  = "Subnets list"
  default      = {
    default_subnet = {
      cidr_block       = null
      is_public        = false
    }
  }
}

variable "route_table_id" {
  type = string
  description = "Route table ID"
  default = null
}
