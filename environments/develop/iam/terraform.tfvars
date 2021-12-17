homeregion = "us-ashburn-1"
region     = "us-ashburn-1"

compartment = {
    name = "dev"
    description = "This compartment is for development."
    }

users = { 
dev_admin = { 
  description = "Administrator for dev compartment." 
  email       = null
  groups      = ["dev_admin_group"]
} }

groups = { 
dev_admin_group = {
  compartment_name    = "dev"
  description         = "Administrator for dev compartment"
  statements_tpl_path = "./templates/administrator_policy.tftpl"
} }