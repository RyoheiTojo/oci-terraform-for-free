terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      source  = "hashicorp/oci"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  region           = var.homeregion
}

module "compute-instance" {
  source       = "../../../modules/compute-instance"

  tenancy_ocid        = var.tenancy_ocid
  compartment_name    = var.compartment_name
  vcn_name            = var.vcn_name
  ad_index            = var.ad_index
  ssh_authorized_keys = var.ssh_authorized_keys
  user_data           = var.user_data
  computes            = var.computes
}
