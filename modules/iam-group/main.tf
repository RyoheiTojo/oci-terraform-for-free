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
  compartment_id = var.tenancy_ocid
  statements     = split("\n", templatefile("${path.module}/${each.value.statements_tpl_path}", {group_name: each.key, compartment_name: each.value.compartment_name}))
}
