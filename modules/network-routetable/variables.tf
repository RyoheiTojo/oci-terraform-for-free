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

variable "routetable_name" {
  type = string
  description = "Target routetable name"
  default = null
}

variable "internet_gateway_id" {
  type        = string
  description = "Internaet gateway ID"
  default     = null
}

variable "vcn_id" {
  type        = string
  description = "VCN ID"
  default     = null
}
