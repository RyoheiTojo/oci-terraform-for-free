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
  vcn              = var.vcn
}

module "network-subnets" {
  source           = "../../../modules/network-subnet"

  subnets          = var.subnets
  tenancy_ocid     = var.tenancy_ocid
  compartment_name = var.vcn.compartment_name
  vcn_name         = var.vcn.name
  route_table_id   = module.network-routetable.this.id
}

module "network-nsg" {
  source           = "../../../modules/network-nsg"

  tenancy_ocid            = var.tenancy_ocid
  compartment_name        = var.vcn.compartment_name
  vcn_name                = var.vcn.name
  network_security_groups = var.network_security_groups
}

module "network-internetgateway" {
  source           = "../../../modules/network-internetgateway"

  tenancy_ocid          = var.tenancy_ocid
  compartment_name      = var.vcn.compartment_name
  vcn_name              = var.vcn.name
  internet_gateway_name = var.internet_gateway_name
}

module "network-routetable" {
  source           = "../../../modules/network-routetable"

  tenancy_ocid          = var.tenancy_ocid
  vcn_id                = module.network-vcn.this.id
  compartment_name      = var.vcn.compartment_name
  routetable_name       = var.routetable_name
  internet_gateway_id   = var.has_internet_gateway ? module.network-internetgateway.this.id : null
}
