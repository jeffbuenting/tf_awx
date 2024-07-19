output "VMIP" {
  description = "IP of the VM"
  value       = proxmox_virtual_environment_vm.vm.ipv4_addresses
}

# output "ubuntu_vm_password" {
#   value     = random_password.ubuntu_vm_password.result
#   sensitive = true
# }

# output "ubuntu_vm_private_key" {
#   value     = tls_private_key.ubuntu_vm_key.private_key_pem
#   sensitive = true
# }
