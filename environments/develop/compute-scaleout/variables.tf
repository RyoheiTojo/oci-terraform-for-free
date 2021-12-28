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
    shape_config            = object({
      memory_in_gbs = number,
      ocpus         = number,
    })
    network_security_groups = list(string),
    private_ip              = string,
    subnet_name             = string,
    defined_tags            = map(string),
    additional_vnic         = list(object({
      private_ip       = string,
      assign_public_ip = bool,
      subnet_name      = string,
    }))
  }))
  description = "Computes list"
  default = {
    default-compute = {
      assign_public_ip        = false
      fd_index                = null
      network_security_groups = []
      private_ip              = null
      shape                   = null
      shape_config            = null
      subnet_name             = null
      defined_tags            = {}
      additional_vnic         = []
    }
  }
}

variable "base_boot_volume_id" {
  type = string
  description = "Original boot volume OCID"
  default = null
}