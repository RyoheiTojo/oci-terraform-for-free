homeregion            = "us-ashburn-1"
internet_gateway_name = "dev_internet_gateway"
service_gateway_name  = "dev_service_gateway"

route_tables = {
  public = {
    internet_gateway_destinations = ["0.0.0.0/0"]
    service_gateway_destinations  = []
  },
  managements = {
    internet_gateway_destinations = []
    service_gateway_destinations  = ["all-iad-services-in-oracle-services-network"] # format: all-<region>-services-in-oracle-services-network
  },
  applications = {
    internet_gateway_destinations = []
    service_gateway_destinations  = ["all-iad-services-in-oracle-services-network"] # format: all-<region>-services-in-oracle-services-network
  }
}

vcn = {
  name             = "dev"
  cidr_block       = "10.1.0.0/16"
  compartment_name = "dev"
}

subnets = {
  public = {
    cidr_block       = "10.1.0.0/24"
    is_public        = true
    route_table_name = "public"
  },
  applications = {
    cidr_block       = "10.1.1.0/24"
    is_public        = false
    route_table_name = "applications"
  },
  managements = {
    cidr_block       = "10.1.2.0/24"
    is_public        = false
    route_table_name = "managements"
  }
}

network_security_groups = {
  public = [{
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
  applications = [{
    direction    = "INGRESS"
    src_type     = "NSG"
    src          = "managements"
    protocol     = "TCP"
    src_port     = null
    dest_type    = null
    dest         = null
    dest_port    = [{min: 8507, max: 8508}] # geth http.port
    stateless    = false
    icmp_options = null
  },{
    direction    = "INGRESS"
    src_type     = "NSG"
    src          = "public"
    protocol     = "TCP"
    src_port     = null
    dest_type    = null
    dest         = null
    dest_port    = [{min: 8507, max: 8508}] # geth http.port
    stateless    = false
    icmp_options = null
  }],
  managements  = [],
}
