data "oci_identity_fault_domains" "this" {
  availability_domain = data.oci_identity_availability_domains.this.availability_domains[var.ad_num].name
  compartment_id = data.oci_identity_compartments.this.compartments[0].id
}

data "oci_identity_availability_domains" "this" {
    compartment_id = var.tenancy_ocid
}

data "oci_identity_compartments" "this" {
  compartment_id = var.tenancy_ocid
  compartment_id_in_subtree = true

  filter {
    name   = "name"
    values = [var.compartment_name] # TODO: there is a posibility to match several candidates.
  }
}

data "oci_core_vcns" "this" {
  compartment_id = data.oci_identity_compartments.this.compartments[0].id
  display_name   = var.vcn_name
}

data "oci_core_subnets" "this" {
  compartment_id = data.oci_identity_compartments.this.compartments[0].id
  vcn_id         = data.oci_core_vcns.this.virtual_networks[0].id
}

resource "oci_core_instance" "this" {
  for_each = var.instances

  availability_domain = data.oci_identity_availability_domains.this.availability_domains[var.ad_num].name
  compartment_id      = data.oci_identity_compartments.this.compartments[0].id
  display_name        = each.value.display_name
  fault_domain        = each.value.fd_num != null ? data.oci_identity_fault_domains.this.fault_domains[each.value.fd_num].name : null
  shape               = each.value.shape

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data           = var.user_data
  }

  create_vnic_details {
    subnet_id        = [for s in data.oci_core_subnets.this.subnets: s.id if s.display_name == each.value.subnet_name][0]
    assign_public_ip = each.value.assign_public_ip
  }

  source_details {
    source_type = each.value.src_type
    source_id   = each.value.src_id
  }
}
