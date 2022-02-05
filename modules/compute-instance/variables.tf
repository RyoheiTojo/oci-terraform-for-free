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

variable "ad_index" {
  type        = number
  description = "Availability domain index"
  default     = 0 # You can choose between 0 and 2.
}

variable "ssh_authorized_keys" {
  type        = string
  description = "Public key for ssh"
  default     = null
}

variable "user_data" {
  type        = string
  description = "Userdata"
  default     = null
}

variable "computes" {
  type = map(object({
    assign_public_ip        = bool,
    fd_index                = number, # You can choose between 0 and 2 or null.
    shape                   = string,
    shape_config            = object({
      memory_in_gbs = number,
      ocpus         = number,
    })
    network_security_groups = list(string),
    private_ip              = string,
    subnet_name             = string, # Note: subnet's display_name has to be unique. consider alternative key.
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
  description = "Information of instances you want to create."
  default     = {
    default_instance = {
      assign_public_ip        = false
      fd_index                = null
      shape                   = null
      shape_config            = null
      network_security_groups = []
      private_ip              = null
      subnet_name             = null
      source_type             = null
      source                  = null
      defined_tags            = {}
      additional_vnic         = []
      block_volumes           = []
    }
  }
}

variable "blockvolume_ids" {
  type = map(string) 
  description = "Blockvolume OCIDs"
  default = {
    "default_blockvolume" = null
  }
}

variable "vcn_name" {
  type = string
  description = "Target vcn name"
  default = null
}
