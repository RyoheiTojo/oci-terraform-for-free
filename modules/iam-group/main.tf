terraform {
  required_version = ">= 0.12"
  required_providers {
    oci = {
      version = ">= 3.27"
    }
  }
}

data "oci_identity_compartments" "this" {
  compartment_id = var.tenancy_ocid
  compartment_id_in_subtree = true
}

resource "oci_identity_group" "this" {
  for_each = var.groups

  compartment_id = var.tenancy_ocid
  name           = each.key
  description    = each.value.description
}

resource "oci_identity_user_group_membership" "this" {
  count    = var.user_ids == null ? 0 : length(var.user_ids)
  user_id  = var.user_ids[count.index]
  group_id = oci_identity_group.this["dev_admin_group"].id
}

resource "oci_identity_policy" "this" {
  for_each = var.groups
  depends_on     = [oci_identity_group.this]

  name           = "${each.key}-policy"
  description    = each.value.description
  compartment_id = [for c in data.oci_identity_compartments.this.compartments: c.id if c.name == each.value.compartment_name][0]
  statements     = split("\n", templatefile("${path.module}/${each.value.statements_tpl_path}", {group_name: each.key, compartment_name: each.value.compartment_name}))
}
