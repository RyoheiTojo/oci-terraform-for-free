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

locals {
  groupid_userid_list = [for k,v in var.membership_ids: setproduct([oci_identity_group.this[k].id], v)][0]
}

resource "oci_identity_user_group_membership" "this" {
  count    = length(local.groupid_userid_list)

  user_id  = local.groupid_userid_list[count.index][1]
  group_id = local.groupid_userid_list[count.index][0]
}

resource "oci_identity_policy" "this" {
  for_each = var.groups
  depends_on     = [oci_identity_group.this]

  name           = "${each.key}-policy"
  description    = each.value.description
  compartment_id = [for c in data.oci_identity_compartments.this.compartments: c.id if c.name == each.value.compartment_name][0]
  statements     = split("\n", templatefile("${path.module}/${each.value.statements_tpl_path}", {group_name: each.key, compartment_name: each.value.compartment_name}))
}
