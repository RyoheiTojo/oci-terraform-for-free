homeregion            = "us-ashburn-1"
internet_gateway_name = "dev_internet_gateway"
has_internet_gateway  = true
routetable_name       = "dev_route_table"

vcn = {
  name             = "dev_vcn"
  cidr_block       = "10.1.0.0/16"
  compartment_name = "dev"
}

subnets = {
  public-subnet = {
    cidr_block = "10.1.0.0/24"
    is_public  = true
  },
  private-subnet = {
    cidr_block = "10.1.1.0/24"
    is_public  = false
  }
}