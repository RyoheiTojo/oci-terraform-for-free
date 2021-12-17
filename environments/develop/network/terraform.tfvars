compartment_name      = "dev"
homeregion            = "us-ashburn-1"
vcn_cidr              = "10.1.0.0/16"
label_prefix          = "none"
vcn_dns_label         = "vcn"
enable_ipv6           = false
freeform_tags         = {}
vcn_name              = "dev_vcn"
internet_gateway_name = "dev_internet_gateway"
has_internet_gateway  = true
routetable_name       = "dev_route_table"

vcn = {
  name             = "dev_vcn"
  cidr_block       = "10.1.0.0/16"
  compartment_name = "dev"
}