variable "compartment_name" {}
variable "tenancy_ocid" {}
variable "homeregion" {}
variable "vcn_cidr" {}
variable "label_prefix" {}
variable "vcn_dns_label" {}
variable "enable_ipv6" {}
variable "freeform_tags" {}
variable "vcn_name" {}

terraform {
  required_version = ">= 0.12"
  required_providers {
    oci = {
      version = ">= 3.27, < 4.0" // force downloading oci-provider compatible with terraform v0.12
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  region           = var.homeregion
}

module "network-vcn" {
  source           = "../../../modules/network-vcn"
  tenancy_ocid     = var.tenancy_ocid
  compartment_name = var.compartment_name
  vcn_cidr         = var.vcn_cidr
  vcn_dns_label    = var.vcn_dns_label
  label_prefix     = var.label_prefix
  enable_ipv6      = var.enable_ipv6
  freeform_tags    = var.freeform_tags
  vcn_name         = var.vcn_name
}

module "network-subnets" {
  source           = "../../../modules/network-subnet"
  subnets = {
    public_subnet = {
      cidr_block    = "10.1.0.0/24",
      display_name  = "public-subnet"
      is_public     = true
    },
    private_subnet = {
      cidr_block    = "10.1.1.0/24",
      display_name  = "private-subnet"
      is_public     = false
    }
  }
  tenancy_ocid     = var.tenancy_ocid
  compartment_name = "dev"
  vcn_name         = "dev_vcn"
}
