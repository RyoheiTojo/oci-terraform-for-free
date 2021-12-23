variable "internet_gateway_name" {
  type = string
  description = "Internet gateway name"
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

variable "vcn_id" {
  type = string
  description = "Target vcn ID"
  default = null
}

