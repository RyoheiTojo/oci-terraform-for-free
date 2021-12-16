terraform {
  required_version = ">= 0.12"
  required_providers {
    oci = {
      version = ">= 3.27"
    }
  }
}

resource "oci_identity_user" "this" {
  count          = length(var.users)

  compartment_id = var.tenancy_ocid
  name           = var.users[count.index].name
  description    = var.users[count.index].description
  email          = var.users[count.index].email == null ? "" : var.users[count.index].email
}

