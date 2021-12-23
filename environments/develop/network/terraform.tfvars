homeregion            = "us-ashburn-1"
internet_gateway_name = "dev_internet_gateway"
service_gateway_name  = "dev_service_gateway"

route_tables = {
  public_route_table = {
    internet_gateway_destinations = ["0.0.0.0/0"]
    service_gateway_destinations  = []
  },
  inner_route_table = {
    internet_gateway_destinations = []
    service_gateway_destinations  = ["all-iad-services-in-oracle-services-network"] # format: all-<region>-services-in-oracle-services-network
  }
}

vcn = {
  name             = "dev_vcn"
  cidr_block       = "10.1.0.0/16"
  compartment_name = "dev"
}

subnets = {
  public-subnet = {
    cidr_block       = "10.1.0.0/24"
    is_public        = true
    route_table_name = "public_route_table"
  },
  private-subnet = {
    cidr_block       = "10.1.1.0/24"
    is_public        = false
    route_table_name = "inner_route_table"
  }
}

network_security_groups = {
  public-subnet-nsg = [{
    direction    = "INGRESS"
    src_type     = "CIDR"
    src          = "0.0.0.0/0"
    protocol     = "TCP"
    src_port     = null
    dest_type    = null
    dest         = null
    dest_port    = [{min: 22, max: 22}]
    stateless    = false
    icmp_options = null
  }],
  private-subnet-nsg = [],
}
