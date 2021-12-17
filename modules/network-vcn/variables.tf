variable "tenancy_ocid" {
  type = string
  description = "The name to root compartment ocid."
  default     = null
}

variable "vcn" {
  type = object({
    name             = string,
    compartment_name = string,
    cidr_block       = string,
  })
  description = "VCN"
  default = {
    name             = null
    compartment_name = null
    cidr_block       = null
  }
}

variable "compartment_name" {
  type = string
  description = "The name to pick up filtering compartment for vcn config."
  default     = null
}

variable "vcn_cidr" {
  description = "The IPv4 CIDR block the VCN will use."
  default     = "10.0.0.0/16"
  type        = string
}

variable "vcn_dns_label" {
  description = "A DNS label for the VCN, used in conjunction with the VNIC's hostname and subnet's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet"
  type        = string
  default     = "vcnmodule"
}

variable "label_prefix" {
  description = "a string that will be prepended to all resources"
  type        = string
  default     = "none"
}

variable "freeform_tags" {
  description = "simple key-value pairs to tag the created resources using freeform OCI Free-form tags."
  type        = map(any)
  default = {
    terraformed = "Please do not edit manually"
  }
}

variable "enable_ipv6" {
  description = "Whether IPv6 is enabled for the VCN. If enabled, Oracle will assign the VCN a IPv6 /56 CIDR block."
  type        = bool
  default     = false
}

variable "vcn_name" {
  description = "user-friendly name of to use for the vcn to be appended to the label_prefix"
  type        = string
  default     = "vcn"
}
