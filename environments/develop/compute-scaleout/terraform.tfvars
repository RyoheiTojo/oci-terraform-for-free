homeregion          = "us-ashburn-1"
ssh_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCJedWKkobbk4zk8IwYTqtBfjTKaEnI3q7ob3jpU+dOK7+8wl8o+qJhA9u66S1dvNXkE1n1BocjV2aiScIF67PROPaBjP0iFcXu2oRxRkCCzQX5RhrNNz04xiJJ1prE22UDYa3NHe8scRZBDRqeOf5MaeKZyCuC9s9o4610MI8DRCJM+dD1285YevRA4ncKdYNiV56Y8xI4lL5XuScoaw5XI3kd6RzTk/TivIWsSgnVV1+BJbPnZJR86/st+AmcuFDzXYVyKYNC80t0uoaBB1ETIBKmiZPwHS3F/F/iKMpPiQzG+vBCMGAY0SLlAQ+xhBVJc2PwxWx8Ix7lePqOUSib ssh-key-2021-01-28"
user_data           = "I2Nsb3VkLWNvbmZpZw0KdGltZXpvbmU6IEFzaWEvVG9reW8NCmxvY2FsZTogamFfSlAudXRmOCANCnJ1bmNtZDoNCiAgLSBzZXRlbmZvcmNlIDANCiAgLSBzZWQgLWkgLWUgJ3MvXlxTRUxJTlVYPWVuZm9yY2luZy9TRUxJTlVYPWRpc2FibGVkLycgL2V0Yy9zZWxpbnV4L2NvbmZpZw0KICAtIHN5c3RlbWN0bCByZXN0YXJ0IHJzeXNsb2ciDQpwb3dlcl9zdGF0ZTogDQogIGRlbGF5OiAiKzEwIiANCiAgbW9kZTogcmVib290DQogIG1lc3NhZ2U6IEJ5ZSBCeWUgDQogIHRpbWVvdXQ6IDMw"

compartment_name = "dev"
vcn_name = "dev_vcn"
ad_index = 2 # AD-3

computes = {
  testserver2 = {
    assign_public_ip        = false
    fd_index                = null # Feeling lucky.
    shape                   = "VM.Standard.E2.1.Micro"
    shape_config            = null
    network_security_groups = ["private-subnet-nsg"]
    private_ip              = "10.1.1.21",
    subnet_name             = "private-subnet"
    defined_tags            = {"dev_tag_namespace.use-oci-cli" = "no"}
    additional_vnic         = []
  }
}
