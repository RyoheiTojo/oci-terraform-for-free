variable "tenancy_ocid" {}
variable "homeregion" {}
variable "internet_gateway_name" {}
variable "has_internet_gateway" {}
variable "routetable_name" {}

variable "vcn" {
  type = object({
    name             = string,
    compartment_name = string,
    cidr_block       = string,
  })
  description = "VCN"
  default = {
    name             = null
    compartment_name = null
    cidr_block       = null
  }
}

variable "subnets" {
  type = map(object({
    cidr_block = string,
    is_public  = bool,
  }))
  description = "Subnets list"
  default = {
    default-subnet = {
      cidr_block = null
      is_public  = false
    }
  }
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
