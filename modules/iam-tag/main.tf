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

variable "tag_namespace" {
  type = object({
      name        = string,
      description = string,
  })
  description = "Settings of tag namespace"
  default = {
    description = null
    name        = null
  }
}

resource "oci_identity_tag_namespace" "this" {
  compartment_id = data.oci_identity_compartments.this.compartments[0].id

  name        = var.tag_namespace.name
  description = var.tag_namespace.description
}