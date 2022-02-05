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