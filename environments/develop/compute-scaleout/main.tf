terraform {
  required_version = ">= 0.13"
  required_providers {
    oci = {
      version = ">= 3.27"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  region           = var.homeregion
}

module "compute-bootvolume" {
  source       = "../../../modules/compute-bootvolume"
    
  tenancy_ocid     = var.tenancy_ocid
  ad_index         = var.ad_index
  compartment_name = var.compartment_name
  boot_volumes     = {for k,v in var.computes: k=>{source_type: "bootVolume", source_id: var.base_boot_volume_id}}
}

module "compute-instance" {
  source       = "../../../modules/compute-instance"

  tenancy_ocid        = var.tenancy_ocid
  compartment_name    = var.compartment_name
  vcn_name            = var.vcn_name
  ad_index            = var.ad_index
  ssh_authorized_keys = var.ssh_authorized_keys
  user_data           = var.user_data
  computes            = {for k,v in var.computes: k=>merge(v, {source_type: "bootVolume", source: module.compute-bootvolume.this[k].id})}
}
