output "computes" {
  description = "Scaled out computes list"
  value = module.compute-instance.this
}

output "bootvolumes" {
  description = "Scaled out bootvolumes list"
  value = module.compute-bootvolume.this
}