terraform {
  required_version = ">= 0.12"
  required_providers {
    oci = {
      version = ">= 3.27"
    }
  }
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

data "oci_identity_compartments" "this" {
  compartment_id = var.tenancy_ocid
  compartment_id_in_subtree = true
}

resource "oci_identity_dynamic_group" "this" {
  for_each = var.dynamic_groups

  compartment_id = var.tenancy_ocid
  name           = each.key
  description    = each.value.description
  matching_rule  = each.value.matching_rule
}

resource "oci_identity_policy" "this" {
  for_each = var.dynamic_groups
  depends_on = [oci_identity_dynamic_group.this]

  name           = "${each.key}-policy"
  description    = each.value.description
  compartment_id = [for c in data.oci_identity_compartments.this.compartments: c.id if c.name == each.value.compartment_name][0]
  statements     = split("\n", templatefile("${path.module}/${each.value.statements_tpl_path}", {group_name: each.key, compartment_name: each.value.compartment_name}))
}
