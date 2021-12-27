terraform {
  required_version = ">= 0.12"
  required_providers {
    oci = {
      version = ">= 3.27"
    }
  }
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
  compartment_id = var.tenancy_ocid
  statements     = split("\n", templatefile("${path.module}/${each.value.statements_tpl_path}", {group_name: each.key, compartment_name: each.value.compartment_name}))
}
