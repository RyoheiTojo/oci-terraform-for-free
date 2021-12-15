variable "compartment_name" {}
variable "tenancy_ocid" {}
variable "homeregion" {}
variable "vcn_cidr" {}
variable "label_prefix" {}
variable "vcn_dns_label" {}
variable "enable_ipv6" {}
variable "freeform_tags" {}
variable "vcn_name" {}
variable "internet_gateway_name" {}
variable "has_internet_gateway" {}
variable "routetable_name" {}

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
  route_table_id   = module.network-routetable.route_table_id
}

module "network-nsg" {
  source           = "../../../modules/network-nsg"
  network_security_groups = {
    nsg001 = {
      display_name  = "public-subnet-nsg"
    },
    nsg002 = {
      display_name  = "private-subnet-nsg"
    }
  }
  tenancy_ocid     = var.tenancy_ocid
  compartment_name = "dev"
  vcn_name         = "dev_vcn"
  network_security_group_rules = {
    rule001 = {
      nsg_name     = "public-subnet-nsg"
      direction    = "INGRESS"
      src_type     = "CIDR"
      src          = "0.0.0.0/0"
      protocol     = "TCP"
      src_port     = null
      dest_type    = null
      dest         = null
      dest_port    = [{min: 22, max: 22}]
      stateless    = false
      icmp_options = null
    },
  }
}

module "network-internetgateway" {
  source           = "../../../modules/network-internetgateway"

  tenancy_ocid          = var.tenancy_ocid
  compartment_name      = var.compartment_name
  vcn_name              = var.vcn_name
  internet_gateway_name = var.internet_gateway_name
}

module "network-routetable" {
  source           = "../../../modules/network-routetable"

  tenancy_ocid          = var.tenancy_ocid
  vcn_id                = module.network-vcn.vcn_id
  compartment_name      = var.compartment_name
  routetable_name       = var.routetable_name
  internet_gateway_id   = var.has_internet_gateway ? module.network-internetgateway.internet_gateway_id : null
}
