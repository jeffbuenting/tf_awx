terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.60.1"
    }
  }
}

provider "proxmox" {
  endpoint = "https://${var.pveip}:8006/"
  username = "${var.username}@pam"
  password = var.password
  insecure = true
  # uncomment (unless on Windows...)
  # tmp_dir  = "/var/tmp"

  ssh {
    agent = true
    # TODO: uncomment and configure if using api_token instead of password
    # username = "root"
  }
}
