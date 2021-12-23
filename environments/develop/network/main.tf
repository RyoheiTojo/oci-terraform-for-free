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
  vcn_id           = module.network-vcn.this.id
  route_tables     = {for k,v in module.network-routetable.this: k=>v.id}
}

module "network-nsg" {
  source           = "../../../modules/network-nsg"

  tenancy_ocid            = var.tenancy_ocid
  compartment_name        = var.vcn.compartment_name
  vcn_id                  = module.network-vcn.this.id
  network_security_groups = var.network_security_groups
}

module "network-internetgateway" {
  source           = "../../../modules/network-internetgateway"

  tenancy_ocid          = var.tenancy_ocid
  compartment_name      = var.vcn.compartment_name
  vcn_id                = module.network-vcn.this.id
  internet_gateway_name = var.internet_gateway_name
}

module "network-servicegateway" {
  source           = "../../../modules/network-servicegateway"

  tenancy_ocid          = var.tenancy_ocid
  compartment_name      = var.vcn.compartment_name
  vcn_id                = module.network-vcn.this.id
  service_gateway_name  = var.service_gateway_name
  service_cider_block   = var.service_cider_block
}

module "network-routetable" {
  source           = "../../../modules/network-routetable"

  tenancy_ocid          = var.tenancy_ocid
  vcn_id                = module.network-vcn.this.id
  compartment_name      = var.vcn.compartment_name
  route_tables          = var.route_tables
  internet_gateway_id   = module.network-internetgateway.this.id
  service_gateway_id    = module.network-servicegateway.this.id
}
