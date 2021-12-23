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

module "iam_compartment" {
  source                  = "../../../modules/iam-compartment"
  tenancy_ocid            = var.tenancy_ocid
  compartment_id          = var.tenancy_ocid # define the parent compartment. Creation at tenancy root if omitted
  compartment_name        = var.compartment.name
  compartment_description = var.compartment.description
  enable_delete           = true
}

module "iam_users" {
  source       = "../../../modules/iam-user"

  tenancy_ocid = var.tenancy_ocid
  users        = {for k,v in var.users: k=>{description: v.description, email: v.email}}
}

module "iam_group" {
  source         = "../../../modules/iam-group"
  tenancy_ocid   = var.tenancy_ocid
  groups         = var.groups
  membership_ids = transpose({for k,v in var.users: module.iam_users.this[k].id=>v.groups})
}

module "iam_tag" {
  source = "../../../modules/iam-tag"

  tenancy_ocid     = var.tenancy_ocid
  compartment_name = var.compartment.name
  tags             = var.tags
}

module "iam_dynamic_group" {
  source = "../../../modules/iam-dynamic-group"

  tenancy_ocid   = var.tenancy_ocid
  dynamic_groups = var.dynamic_groups
}
