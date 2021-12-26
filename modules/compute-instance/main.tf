data "oci_core_network_security_groups" "this" {
  compartment_id = data.oci_identity_compartments.this.compartments[0].id
  vcn_id         = data.oci_core_vcns.this.virtual_networks[0].id
}

data "oci_identity_fault_domains" "this" {
  availability_domain = data.oci_identity_availability_domains.this.availability_domains[var.ad_index].name
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
  for_each = var.computes

  availability_domain = data.oci_identity_availability_domains.this.availability_domains[var.ad_index].name
  compartment_id      = data.oci_identity_compartments.this.compartments[0].id
  display_name        = each.key
  fault_domain        = each.value.fd_index != null ? data.oci_identity_fault_domains.this.fault_domains[each.value.fd_index].name : null
  shape               = each.value.shape
  defined_tags        = each.value.defined_tags

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data           = var.user_data
  }

  create_vnic_details {
    subnet_id        = [for s in data.oci_core_subnets.this.subnets: s.id if s.display_name == each.value.subnet_name][0]
    assign_public_ip = each.value.assign_public_ip
    nsg_ids          = [for nsg in data.oci_core_network_security_groups.this.network_security_groups: nsg.id if contains(each.value.network_security_groups, nsg.display_name)]
  }

  source_details {
    source_type = each.value.source_type
    source_id   = each.value.source
  }
}

locals {
  flatten_vnics = flatten([
    for compute_name, compute_data in var.computes: {
      for vnic in compute_data.additional_vnic: "${compute_name}-${vnic.private_ip}"=>{compute: compute_name, private_ip: vnic.private_ip, assign_public_ip: vnic.assign_public_ip, subnet_name: vnic.subnet_name}
    }
  ])
}

resource "oci_core_vnic_attachment" "this" {
  for_each = local.flatten_vnics

  create_vnic_details {
      subnet_id = [for s in data.oci_core_subnets.this.subnets: s.id if s.display_name == each.value.subnet_name][0]
      assign_public_ip = each.value.assign_public_ip
      private_ip = each.value.private_ip
  }
  instance_id = [for k,v in oci_core_instance.this: v.id if k == each.value.compute][0]
}