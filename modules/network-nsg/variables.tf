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

variable "vcn_id" {
  type = string
  description = "Target vcn ID"
  default = null
}

variable "network_security_groups" {
  type         = map(list(object({ # Key is NSG name
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
  })))
  description  = "Parameters for each nsg rule to be created/managed."
  default      = {
    default_nsg = []
  }
}
