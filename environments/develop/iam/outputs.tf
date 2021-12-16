output "iam_compartment" {
  description = "Compartment name, description, id, and compartment_id"
  value = {
    name           = module.iam_compartment.name,
    description    = module.iam_compartment.description,
    id             = module.iam_compartment.id,
    compartment_id = module.iam_compartment.compartment_id
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
