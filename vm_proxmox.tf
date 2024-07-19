

resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.vmname
  description = "Managed by Terraform"
  tags        = ["terraform", "ubuntu"]

  node_name = var.pvename
  vm_id     = var.vmid

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = true
  }
  # if agent is not enabled, the VM may not be able to shutdown properly, and may need to be forced off
  stop_on_destroy = true

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  cpu {
    architecture = "x86_64"
    cores        = 2
    type         = "host"
  }

  memory {
    dedicated = var.vmmem
  }

  disk {
    datastore_id = "local-dir"
    file_id      = "local-dir:iso/jammy-server-cloudimg-amd64.img"
    interface    = "scsi0"
    size         = var.vmdisksize
  }


  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
        # address = "192.168.68.49/22"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.cloudinit.id

  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  tpm_state {
    version = "v2.0"
  }

  serial_device {}

}

resource "proxmox_virtual_environment_file" "cloudinit" {
  content_type = "snippets"
  datastore_id = "local-dir"
  node_name    = var.pvename

  source_raw {
    data = <<-EOF
    ${data.template_file.userdata.rendered}
    EOF

    file_name = "${var.vmname}_user_data.yaml"
  }
}

# Get the public SSH key to install on the new node
data "template_file" "ssh_key" {

  template = file("${var.sshkeypath}//${var.ssh_rsa_keyfile}")
}

data "template_file" "kustomization_file" {

  template = filebase64(".//kustomization.yml")
}

data "template_file" "awx_yml" {
  template = file(".//awx.yml")

  vars = {
    awx_superuser          = var.vmuser
    awx_superuser_email    = var.awx_superuser_email
    awx_superuser_password = var.vmuserpassword
  }
}

# supply variables to userdata ( this will be saved to proxmox later )
data "template_file" "userdata" {

  template = file(".//cloudinit.yaml")

  vars = {
    ssh_rsa_key        = data.template_file.ssh_key.rendered
    adminuser          = var.vmuser
    adminpassword      = "${bcrypt(var.vmuserpassword, 6)}"
    vmname             = var.vmname
    kustomization_file = data.template_file.kustomization_file.rendered
    awx_yml            = base64encode(data.template_file.awx_yml.rendered)
  }
}

