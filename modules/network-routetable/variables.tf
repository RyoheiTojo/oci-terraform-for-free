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
    has_internet_gateway = bool,
    has_service_gateway  = bool,
  }))
  description = "Route tables"
  default = {
    default_table = {
      has_internet_gateway = false # Both of them cannot be true at same time.
      has_service_gateway  = false
    }
  }
}