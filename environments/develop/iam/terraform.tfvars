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
  groups      = ["dev_admin"]
} }

groups = { 
dev_admin = {
  compartment_name    = "dev"
  description         = "Administrator for dev compartment"
  statements_tpl_path = "./templates/administrator_policy.tftpl"
} }

tags = { 
  dev = { 
    description  = "TagNamespace for dev"
    defined_tags = {
      use-oci-cli = {
        description    = "Instance principal for oci-cli"
        validator_type = "ENUM"
        values         = ["yes", "no"]
      },
      test_tag = {
        description    = "test tag"
        validator_type = "DEFAULT"
        values         = null
      }
    }
  }
}

dynamic_groups = {
  oci-client = {
    compartment_name    = "dev"
    description         = "Dynamic group for OCI-CLI"
    matching_rule       = "tag.dev.use-oci-cli.value='yes'"
    statements_tpl_path = "./templates/use_oci_cli_group_policy.tftpl"
  }
}