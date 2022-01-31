homeregion          = "us-ashburn-1"
ssh_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCJedWKkobbk4zk8IwYTqtBfjTKaEnI3q7ob3jpU+dOK7+8wl8o+qJhA9u66S1dvNXkE1n1BocjV2aiScIF67PROPaBjP0iFcXu2oRxRkCCzQX5RhrNNz04xiJJ1prE22UDYa3NHe8scRZBDRqeOf5MaeKZyCuC9s9o4610MI8DRCJM+dD1285YevRA4ncKdYNiV56Y8xI4lL5XuScoaw5XI3kd6RzTk/TivIWsSgnVV1+BJbPnZJR86/st+AmcuFDzXYVyKYNC80t0uoaBB1ETIBKmiZPwHS3F/F/iKMpPiQzG+vBCMGAY0SLlAQ+xhBVJc2PwxWx8Ix7lePqOUSib ssh-key-2021-01-28"
user_data           = "I2Nsb3VkLWNvbmZpZw0KdGltZXpvbmU6IEFzaWEvVG9reW8NCmxvY2FsZTogamFfSlAudXRmOCANCnJ1bmNtZDoNCiAgLSBzZXRlbmZvcmNlIDANCiAgLSBzZWQgLWkgLWUgJ3MvXlxTRUxJTlVYPWVuZm9yY2luZy9TRUxJTlVYPWRpc2FibGVkLycgL2V0Yy9zZWxpbnV4L2NvbmZpZw0KICAtIHN5c3RlbWN0bCByZXN0YXJ0IHJzeXNsb2ciDQpwb3dlcl9zdGF0ZTogDQogIGRlbGF5OiAiKzEwIiANCiAgbW9kZTogcmVib290DQogIG1lc3NhZ2U6IEJ5ZSBCeWUgDQogIHRpbWVvdXQ6IDMw"

compartment_name = "dev"
vcn_name = "dev"
ad_index = 2 # AD-3

# Memo: 
# Free pattern1
# shape  = "VM.Standard.E2.1.Micro"
# source = "ocid1.image.oc1.iad.aaaaaaaaw2wavtqrd3ynbrzabcnrs77pinccp55j2gqitjrrj2vf65sqj5kq" # Free (Oracle-Linux-7.9-2021.04.09-0)
# shape_config = null
# * Check the 'Limits, Quotas and Usage' to see where you deploy this shape. 
#
# Free pattern2
# shape  = "VM.Standard.A1.Flex"
# source = "ocid1.image.oc1.iad.aaaaaaaac6jy4yovh7u6k7qguocu2wroyllwybfro6cir5mz5lsfdy7gg2cq"
# shape_config = {memory_in_gbs: 24, ocpus: 4} * MAX

computes = {
  maintenance = {
    assign_public_ip        = true
    fd_index                = null # Feeling lucky.
    shape                   = "VM.Standard.A1.Flex"
    shape_config            = {memory_in_gbs: 12, ocpus: 2}
    network_security_groups = ["public"]
    private_ip              = "10.1.0.10",
    subnet_name             = "public"
    source_type             = "image"
    source                  = "ocid1.image.oc1.iad.aaaaaaaac6jy4yovh7u6k7qguocu2wroyllwybfro6cir5mz5lsfdy7gg2cq"
    defined_tags            = {"dev.use-oci-cli" = "yes"}
    additional_vnic         = [{
      private_ip       = "10.1.2.10"
      assign_public_ip = false
      subnet_name      = "managements"
    }]
  },
  application01 = {
    assign_public_ip        = false
    fd_index                = null # Feeling lucky.
    shape                   = "VM.Standard.A1.Flex"
    shape_config            = {memory_in_gbs: 12, ocpus: 2}
    network_security_groups = ["applications"]
    private_ip              = "10.1.1.20",
    subnet_name             = "applications"
    source_type             = "image"
    source                  = "ocid1.image.oc1.iad.aaaaaaaac6jy4yovh7u6k7qguocu2wroyllwybfro6cir5mz5lsfdy7gg2cq"
    defined_tags            = {"dev.use-oci-cli" = "no"}
    additional_vnic         = []
  },
  manager01 = {
    assign_public_ip        = false
    fd_index                = null # Feeling lucky.
    shape                   = "VM.Standard.E2.1.Micro"
    shape_config            = null
    network_security_groups = ["managements"]
    private_ip              = "10.1.2.20",
    subnet_name             = "managements"
    source_type             = "image"
    source                  = "ocid1.image.oc1.iad.aaaaaaaaw2wavtqrd3ynbrzabcnrs77pinccp55j2gqitjrrj2vf65sqj5kq" # Free (Oracle-Linux-7.9-2021.04.09-0)
    defined_tags            = {"dev.use-oci-cli" = "no"}
    additional_vnic         = []
  },
  manager02 = {
    assign_public_ip        = false
    fd_index                = null # Feeling lucky.
    shape                   = "VM.Standard.E2.1.Micro"
    shape_config            = null
    network_security_groups = ["managements"]
    private_ip              = "10.1.2.21",
    subnet_name             = "managements"
    source_type             = "image"
    source                  = "ocid1.image.oc1.iad.aaaaaaaaw2wavtqrd3ynbrzabcnrs77pinccp55j2gqitjrrj2vf65sqj5kq" # Free (Oracle-Linux-7.9-2021.04.09-0)
    defined_tags            = {"dev.use-oci-cli" = "no"}
    additional_vnic         = []
  }
}