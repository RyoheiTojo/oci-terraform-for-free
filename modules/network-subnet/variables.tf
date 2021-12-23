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

variable "vcn_id" {
  type = string
  description = "Target vcn ID"
  default = null
}

variable "subnets" {
  type         = map(object({
    cidr_block       = string,
    is_public        = bool,
    route_table_name = string,
  }))
  description  = "Subnets list"
  default      = {
    default_subnet = {
      cidr_block       = null
      is_public        = false
      route_table_name = null
    }
  }
}

variable "route_tables" {
  type = map(string)
  description = "Route tables"
  default = {
    default_route_table = null
  }
}