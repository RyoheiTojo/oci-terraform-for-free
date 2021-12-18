output "namespaces" {
  description = "TagNamespace"
  value = oci_identity_tag_namespace.this
}

output "defined_tags" {
  description = "Defined tags"
  value = {
    default_tags: oci_identity_tag.default_tags
    enum_tags:    oci_identity_tag.enum_tags
  }
}