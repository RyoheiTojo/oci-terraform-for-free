variable "tenancy_ocid" {
  type = string
  description = "Tenancy OCID"
  default = null
}

variable "compartment_id" {
  type = string
  description = "Compartment OCID"
  default = null
}

variable "tags" {
  type = map(object({
      description  = string,
      defined_tags = map(object({
          description    = string,
          validator_type = string,
          values         = list(string),
      }))
  }))
  description = "Settings of tag"
  default = { 
      default_tagnamespace = { 
          description  = null 
          defined_tags = {}
      }
  }
}
