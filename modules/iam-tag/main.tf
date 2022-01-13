locals {
  tag_namespaces = [for k,v in var.tags: k]
}

resource "oci_identity_tag_namespace" "this" {
  count = length(local.tag_namespaces)
  compartment_id = var.compartment_id

  name        = local.tag_namespaces[count.index]
  description = var.tags[local.tag_namespaces[count.index]].description
}

locals {
  defined_default_tags = flatten([for namespace, nsdata in var.tags: [for tagname, tagdata in nsdata.defined_tags: {namespace: namespace, tag: {name: tagname, description: tagdata.description, validator_type: tagdata.validator_type, values: tagdata.values}} if tagdata.validator_type == "DEFAULT"]])
  defined_enum_tags    = flatten([for namespace, nsdata in var.tags: [for tagname, tagdata in nsdata.defined_tags: {namespace: namespace, tag: {name: tagname, description: tagdata.description, validator_type: tagdata.validator_type, values: tagdata.values}} if tagdata.validator_type == "ENUM"]])
}

resource "oci_identity_tag" "default_tags" {
  count = length(local.defined_default_tags)
  
  tag_namespace_id = [for n in oci_identity_tag_namespace.this: n.id if n.name == local.defined_default_tags[count.index].namespace][0]
  description = local.defined_default_tags[count.index].tag.description
  name        = local.defined_default_tags[count.index].tag.name
}

resource "oci_identity_tag" "enum_tags" {
  count = length(local.defined_enum_tags)
  
  tag_namespace_id = [for n in oci_identity_tag_namespace.this: n.id if n.name == local.defined_enum_tags[count.index].namespace][0]
  description = local.defined_enum_tags[count.index].tag.description
  name        = local.defined_enum_tags[count.index].tag.name

  validator {
    validator_type = local.defined_enum_tags[count.index].tag.validator_type
    values         = local.defined_enum_tags[count.index].tag.values
  }
}