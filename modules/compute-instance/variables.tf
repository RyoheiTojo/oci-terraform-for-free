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

variable "ad_num" {
  type        = number
  description = "Availability domain number"
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

variable "instances" {
  type = map(object({
    display_name     = string,
    assign_public_ip = bool,
    fd_num           = number, # You can choose between 0 and 2 or null.
    shape            = string,
    nsgs             = list(string),
    subnet_name      = string, # Note: subnet's display_name has to be unique. consider alternative key.
    src_type         = string,
    src_id           = string,
  }))
  description = "Information of instances you want to create."
  default     = {
    default_instance = {
      display_name     = null
      assign_public_ip = false
      fd_num           = null
      shape            = null
      nsgs             = []
      subnet_name      = null
      src_type         = null
      src_id           = null
    }
  }
}

variable "vcn_name" {
  type = string
  description = "Target vcn name"
  default = null
}
