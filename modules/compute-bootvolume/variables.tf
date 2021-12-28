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

variable "boot_volumes" {
  type = map(object({
    source_id   = string,
    source_type = string,
  }))
  description = "Source type of the boot volumes"
  default = {
    "default_boot_volume" = {
      source_id   = null
      source_type = null
    }
  }
}