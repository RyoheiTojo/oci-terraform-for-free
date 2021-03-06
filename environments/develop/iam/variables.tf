variable "tenancy_ocid" {}
variable "compartment_ocid" {}

variable "homeregion" {}
variable "region" {}

variable "compartment" {
  type = object({
    name        = string,
    description = string,
  })
  description = "Compartment definition"
  default = {
    name        = "default_compartment"
    description = "This is default compartment."
  }
}

variable "users" {
  type = map(object({
    description = string,
    email       = string,
    groups      = list(string),
  }))
  description = "Users definitions"
  default = null
}

variable "groups" {
  type = map(object({
    description         = string,
    compartment_name    = string,
    statements_tpl_path = string,
  }))
  description = "Groups definitions"
  default = null
}

variable "dynamic_groups" {
  type = map(object({
    compartment_name    = string,
    description         = string,
    matching_rule       = string,
    statements_tpl_path = string,
  }))
  description = "Dynamic definitions"
  default = {
    default_group = {
      compartment_name    = null
      description         = null
      matching_rule       = null
      statements_tpl_path = null
    }
  }
}

variable "tags" {
  type = map(object({
      description  = string,
      defined_tags = map(object({
          description    = string,
          validator_type = string, # "ENUM" or "DEFAULT"
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