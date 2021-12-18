variable "tenancy_ocid" {}
variable "homeregion" {}
variable "ssh_authorized_keys" {}
variable "user_data" {}

variable "vcn_name" {
  type = string
  description = "Target vcn name"
  default = null
}

variable "compartment_name" {
  type = string
  description = "Target compartment name"
  default = null
}

variable "ad_index" {
  type        = number
  description = "Availability domain index"
  default     = 0 # You can choose between 0 and 2.
}

variable "computes" {
  type = map(object({
    assign_public_ip        = bool,
    fd_index                = number,
    shape                   = string,
    network_security_groups = list(string),
    subnet_name             = string,
    source_type             = string,
    source                  = string,
    defined_tags            = map(string),
  }))
  description = "Computes list"
  default = {
    default-compute = {
      assign_public_ip        = false
      fd_index                = null
      network_security_groups = []
      shape                   = null
      source                  = null
      source_type             = null
      subnet_name             = null
      defined_tags            = {}
    }
  }
}
