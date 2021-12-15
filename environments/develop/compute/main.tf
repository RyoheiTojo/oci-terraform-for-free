variable "tenancy_ocid" {}
variable "homeregion" {}
variable "ssh_authorized_keys" {}
variable "user_data" {}

terraform {
  required_version = ">= 0.12"
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

module "compute-instance" {
  source       = "../../../modules/compute-instance"

  tenancy_ocid        = var.tenancy_ocid
  compartment_name    = "dev"
  vcn_name            = "dev_vcn"
  ad_num              = 2 # AD-3
  ssh_authorized_keys = var.ssh_authorized_keys
  user_data           = var.user_data

  instances        = {
    instance1 = {
      display_name     = "test1"
      assign_public_ip = true
      fd_num           = null # Feeling lucky.
      shape            = "VM.Standard.E2.1.Micro" # Free (Note: Check the 'Limits, Quotas and Usage' to see where you deploy this shape.)
      nsgs             = ["public-subnet-nsg"]
      subnet_name      = "public-subnet"
      src_type         = "image"
      src_id           = "ocid1.image.oc1.iad.aaaaaaaaw2wavtqrd3ynbrzabcnrs77pinccp55j2gqitjrrj2vf65sqj5kq" # Free (Oracle-Linux-7.9-2021.04.09-0)
    }
  }
}
