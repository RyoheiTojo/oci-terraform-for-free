output "iam_compartment" {
  description = "Object of compartment"
  value = module.iam_compartment.this
}

output "iam_users" {
  description = "List of users"
  value       = module.iam_users.this
}

output "iam_groups" {
  description = "List of groups"
  value       = module.iam_group.this
}

output "iam_tags" {
  description = "List of tags"
  value       = {
    tag_namespaces: module.iam_tag.namespaces
    defined_tags:   module.iam_tag.defined_tags
  }
}

#output "iam_dynamic_group_name" {
#  description = "dynamic group name and associated ocid"
#  value       = module.iam_dynamic_group.name_ocid
#}
