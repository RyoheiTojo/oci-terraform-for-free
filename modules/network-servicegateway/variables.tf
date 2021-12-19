variable "service_gateway_name" {
  type = string
  description = "Service gateway name"
  default = null
}

variable "compartment_name" {
  type = string
  description = "Target compartment name"
  default = null
}

variable "tenancy_ocid" {
  type = string
  description = "The tenancy OCID"
  default = null
}

variable "vcn_name" {
  type = string
  description = "Target vcn name"
  default = null
}

variable "route_table_id" {
  type = string
  description = "OCID of the route table"
  default = null
}