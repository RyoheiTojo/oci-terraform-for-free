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
  source         = "../../../modules/iam-tag"

  tenancy_ocid   = var.tenancy_ocid
  compartment_name        = var.compartment.name
  tags = { 
    dev_tag_namespace = { 
      description  = "TagNamespace for dev"
      defined_tags = {
        use-oci-cli = {
          description    = "Instance principal for oci-cli"
          validator_type = "ENUM"
          values         = ["yes", "no"]
        }
      }
    }
  }
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
