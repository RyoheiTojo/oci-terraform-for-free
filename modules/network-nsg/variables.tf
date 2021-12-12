variable "tenancy_ocid" {
  type = string
  description = "The tenancy OCID"
  default = null
}

variable "compartment_name" {
  type = string
  description = "Target compartment name"
  default = null
}

variable "vcn_name" {
  type = string
  description = "Target vcn name"
  default = null
}

variable "network_security_groups" {
  type         = map(object({
    display_name     = string
  }))
  description  = "Parameters for each nsg to be created/managed."
  default      = {
    default_subnet = {
      display_name     = null
    }
  }
}

variable "network_security_group_rules" {
  type         = map(object({
    nsg_name  = string, # NSG name
    direction = string, # INGRESS / EGRESS
    src_type  = string, # CIDR / NSG
    src       = string, # "x.x.x.x/x" when CIDR / "xxx-nsg" when NSG
    protocol  = string, # ALL / TCP / UDP / ICMP
    src_port  = list(object({
      min = number,
      max = number,
    })),
    dest_type = string, # CIDR / NSG
    dest      = string, # "x.x.x.x/x" when CIDR / "xxx-nsg" when NSG
    dest_port = list(object({
      min = number,
      max = number,
    })),
    stateless = bool,
    icmp_options = list(object({
      type = number,
      code = number,
    })),
  }))
  description  = "Parameters for each nsg rule to be created/managed."
  default      = {
    default_nsg = {
      nsg_name     = null
      direction    = null
      src_type     = null
      src          = null
      protocol     = null
      src_port     = []
      dest_type    = null
      dest         = null
      dest_port    = [ ]
      stateless    = false
      icmp_options = null
    }
  }
}
