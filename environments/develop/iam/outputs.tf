// Copyright (c) 2018, 2021, Oracle and/or its affiliates.

output "iam_compartment" {
  description = "compartment name, description, ocid, and parent ocid"
  value = {
    name        = module.iam_compartment.compartment_name,
    description = module.iam_compartment.compartment_description,
    ocid        = module.iam_compartment.id,
    parent      = module.iam_compartment.parent_compartment_id
  }
}

output "iam_users" {
  description = "list of username and associated ocid"
  value       = module.iam_users.name_ocid
}

output "iam_group" {
  description = "group name and associated ocid"
  value       = module.iam_group.name_ocid
}

output "iam_policy" {
  description = "group_policy_name"
  value       = module.iam_group.group_policy_name
}

#output "iam_dynamic_group_name" {
#  description = "dynamic group name and associated ocid"
#  value       = module.iam_dynamic_group.name_ocid
#}
