
# Proxmox VM Variables

variable "pveip" {
  description = "IP address of the PVE server / cluster"
  type        = string
}

variable "pvename" {
  description = "Name  of the PVE server / cluster"
  type        = string
  default     = "proxmox"
}

variable "username" {
  description = "Username with the correct permissions to create VMs on the PVE Server / Cluster"
  type        = string
}

variable "password" {
  description = "Password to username"
  type        = string
}


# VM vars

variable "vmname" {
  description = "name of vm"
  type        = string
  default     = "awx"
}

variable "vmid" {
  description = "ID of the vm"
  type        = number
  default     = "1001"
}


# Cloud config data
variable "vmuser" {
  description = "vm user name"
  type        = string
}

variable "vmuserpassword" {
  description = "vm user password"
  type        = string
}

variable "vmdisksize" {
  description = "Size of HDD in GB"
  type        = number
  default     = 50

}

variable "vmmem" {
  description = "VM memory MB"
  type        = number
  default     = 4096
}

variable "sshkeypath" {
  description = "Path to where the ssh cert is located"
  type        = string
  default     = "c:\\users\\kwbre\\.ssh"
}

variable "ssh_rsa_keyfile" {
  description = ""
  default     = "id_rsa.pub"
}

# AWX Settings
variable "awx_superuser_email" {
  description = "AWX super user email"
  type        = string
  default     = "jeff@jeff.com"
}

