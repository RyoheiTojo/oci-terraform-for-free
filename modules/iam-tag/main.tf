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

locals {
  tag_namespaces = [for k,v in var.tags: k]
}

resource "oci_identity_tag_namespace" "this" {
  count = length(local.tag_namespaces)
  compartment_id = data.oci_identity_compartments.this.compartments[0].id

  name        = local.tag_namespaces[count.index]
  description = var.tags[local.tag_namespaces[count.index]].description
}

locals {
  defined_tags = flatten([for namespace, nsdata in var.tags: [for tagname, tagdata in nsdata.defined_tags: {namespace: namespace, tag: {name: tagname, description: tagdata.description, validator_type: tagdata.validator_type, values: tagdata.values}}]])
}

resource "oci_identity_tag" "this" {
  count = length(local.defined_tags)
  
  tag_namespace_id = [for n in oci_identity_tag_namespace.this: n.id if n.name == local.defined_tags[count.index].namespace][0]
  description = local.defined_tags[count.index].tag.description
  name        = local.defined_tags[count.index].tag.name

  validator {
    validator_type = local.defined_tags[count.index].tag.validator_type
    values         = local.defined_tags[count.index].tag.values
  }
}