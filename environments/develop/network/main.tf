variable "tenancy_ocid" {}
variable "homeregion" {}
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

variable "vcn" {
  type = object({
    name             = string,
    compartment_name = string,
    cidr_block       = string,
  })
  description = "VCN"
  default = {
    name             = null
    compartment_name = null
    cidr_block       = null
  }
}

module "network-vcn" {
  source           = "../../../modules/network-vcn"

  tenancy_ocid     = var.tenancy_ocid
  vcn              = var.vcn
}

variable "subnets" {
  type = map(object({
    cidr_block = string,
    is_public  = bool,
  }))
  description = "Subnets list"
  default = {
    default-subnet = {
      cidr_block = null
      is_public  = false
    }
  }
}

module "network-subnets" {
  source           = "../../../modules/network-subnet"

  subnets          = var.subnets
  tenancy_ocid     = var.tenancy_ocid
  compartment_name = var.vcn.compartment_name
  vcn_name         = var.vcn.name
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
  compartment_name = var.vcn.compartment_name
  vcn_name         = var.vcn.name
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
  internet_gateway_id   = var.has_internet_gateway ? module.network-internetgateway.internet_gateway_id : null
}
