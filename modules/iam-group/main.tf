resource "oci_identity_group" "this" {
  for_each = var.groups

  compartment_id = var.tenancy_ocid
  name           = each.key
  description    = each.value.description
}

locals {
  group_user_list = [for k,v in var.membership: setproduct([k], v)][0]
}

resource "oci_identity_user_group_membership" "this" {
  count    = length(local.group_user_list)

  group_id = oci_identity_group.this[local.group_user_list[count.index][0]].id
  user_id  = var.user_ids[local.group_user_list[count.index][1]]
}

resource "oci_identity_policy" "this" {
  for_each = var.groups
  depends_on     = [oci_identity_group.this]

  name           = "${each.key}-policy"
  description    = each.value.description
  compartment_id = var.tenancy_ocid
  statements     = split("\n", templatefile("${path.module}/${each.value.statements_tpl_path}", {group_name: each.key, compartment_name: each.value.compartment_name}))
}
