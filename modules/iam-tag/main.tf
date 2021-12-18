variable "tenancy_ocid" {
  type = string
  description = "Tenancy OCID"
  default = null
}

variable "compartment_name" {
  type = string
  description = "Compartment name"
  default = null
}

data "oci_identity_compartments" "this" {
  compartment_id = var.tenancy_ocid
  compartment_id_in_subtree = true

  filter {
    name   = "name"
    values = [var.compartment_name] # TODO: there is a posibility to match several candidates.
  }
}

variable "tags" {
  type = map(object({
      description  = string,
      defined_tags = list(object({
          name           = string,
          validator_type = string,
          values         = list(string),
      }))
  }))
  description = "Settings of tag"
  default = { 
      default_tagnamespace = { 
          description  = null 
          defined_tags = []
      }
  }
}

locals {
  tag_namespaces = [for k,v in var.tags: k]
}

resource "oci_identity_tag_namespace" "this" {
  count = length(local.tag_namespaces)
  compartment_id = data.oci_identity_compartments.this.compartments[0].id

  name        = local.tag_namespaces[count.index]
  description = var.tags[local.tag_namespaces[count.index]].description
}