variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "region" {}
variable "homeregion" {}
variable "compartment" {
  type = object({
    name = string,
    description = string,
  })
  description = "Compartment definition"
  default = {
    name = "default_compartment"
    description = "This is default compartment."
  }
}

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
  users = [
    {
      name        = "ryohei"
      description = "user for ryohei"
      email       = null
    },
  ]
}

module "iam_group" {
  source                = "../../../modules/iam-group"
  tenancy_ocid          = var.tenancy_ocid
  group_name            = "dev_admin"
  group_description     = "Admin group for development compartment."
  user_ids              = module.iam_users.user_id
  policy_name           = "dev_admin_policy"
  policy_compartment_id = module.iam_compartment.id
  policy_description    = "Admin policy for development compartment."
  policy_statements = [
    "Allow group ${module.iam_group.group_name} to manage instances in compartment ${module.iam_compartment.compartment_name}",
  ]
}

#module "iam_dynamic_group" {
#  source                    = "oracle-terraform-modules/iam/oci//modules/iam-dyanmic-group"
#  # Pinning each module to a specific version is highly advisable. Please adjust and uncomment the line below
#  # version               = "x.x.x"
#  tenancy_ocid              = var.tenancy_ocid
#  dynamic_group_name        = "tf_example_dynamic_group"
#  dynamic_group_description = "dynamic group created by terraform"
#  matching_rule             = "instance.compartment.id = '${module.iam_compartment.compartment_id}'"
#  policy_compartment_id     = module.iam_compartment.compartment_id
#  policy_name               = "tf-example-dynamic-policy"
#  policy_description        = "dynamic policy created by terraform"
#  policy_statements = [
#    "Allow dynamic-group ${module.iam_dynamic_group.dynamic_group_name} to read instances in compartment tf_example_compartment",
#    "Allow dynamic-group ${module.iam_dynamic_group.dynamic_group_name} to inspect instances in compartment tf_example_compartment",
#  ]
#}
