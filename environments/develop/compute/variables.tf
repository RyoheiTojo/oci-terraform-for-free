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
    source_type             = string,
    source                  = string,
    defined_tags            = map(string),
    additional_vnic         = list(object({
      private_ip       = string,
      assign_public_ip = bool,
      subnet_name      = string,
    })),
    block_volumes           = list(string)
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
      source                  = null
      source_type             = null
      subnet_name             = null
      defined_tags            = {}
      additional_vnic         = []
      block_volumes           = []
    }
  }
}

variable "block_volumes" {
  type = map(object({
      size_in_gbs  = number,
      source_id    = string,
      source_type  = string,
  }))
  description = "Block volumes definitions"
  default = {
    "default_block_volume" = {
      size_in_gbs  = 1
      source_id    = null
      source_type  = null
    }
  }
}