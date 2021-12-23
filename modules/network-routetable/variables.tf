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

variable "internet_gateway_id" {
  type        = string
  description = "Internaet gateway ID"
  default     = null
}

variable "service_gateway_id" {
  type        = string
  description = "Service gateway ID"
  default     = null
}

variable "vcn_id" {
  type        = string
  description = "VCN ID"
  default     = null
}

variable "route_tables" {
  type = map(object({
    internet_gateway_destinations = list(string),
    service_gateway_destinations  = list(string),
  }))
  description = "Route tables"
  default = {
    default_table = {
      internet_gateway_destinations = [] # Both of them cannot be true at same time.
      service_gateway_destinations  = []
    }
  }
}

variable "service_cider_block" {
  type = string
  description = "Service CIDR block"
  default = null
}