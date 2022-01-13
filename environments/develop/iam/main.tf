terraform {
  required_version = ">= 0.14"
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
  user_ids       = {for k,v in module.iam_users.this: k=>v.id}
  groups         = var.groups
  membership     = transpose({for k,v in var.users: k=>v.groups})
}

module "iam_tag" {
  source = "../../../modules/iam-tag"

  tenancy_ocid   = var.tenancy_ocid
  compartment_id = module.iam_compartment.this.id
  tags           = var.tags
}

module "iam_dynamic_group" {
  source = "../../../modules/iam-dynamic-group"

  tenancy_ocid   = var.tenancy_ocid
  dynamic_groups = var.dynamic_groups
}
