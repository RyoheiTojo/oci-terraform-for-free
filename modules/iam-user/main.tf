resource "oci_identity_user" "this" {
  for_each = var.users

  compartment_id = var.tenancy_ocid
  name           = each.key
  description    = each.value.description
  email          = each.value.email == null ? "" : each.value.email
}

