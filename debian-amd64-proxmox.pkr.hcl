packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_iso_checksum" {
  type    = string
  default = "${env("proxmox_iso_checksum")}"
}

variable "proxmox_iso_storage" {
  type    = string
  default = "${env("proxmox_iso_storage")}"
}

variable "proxmox_iso_url" {
  type    = string
  default = "${env("proxmox_iso_url")}"
}

variable "proxmox_network" {
  type    = string
  default = "${env("proxmox_network")}"
}

variable "proxmox_node" {
  type    = string
  default = "${env("proxmox_node")}"
}

variable "proxmox_password" {
  type      = string
  default   = "${env("proxmox_password")}"
  sensitive = true
}

variable "proxmox_storage" {
  type    = string
  default = "${env("proxmox_storage")}"
}

variable "proxmox_url" {
  type    = string
  default = "${env("proxmox_url")}"
}

variable "proxmox_username" {
  type    = string
  default = "${env("proxmox_username")}"
}

variable "proxmox_vm_storage" {
  type    = string
  default = "${env("proxmox_vm_storage")}"
}

variable "ssh_password" {
  type      = string
  default   = "${env("ssh_password")}"
  sensitive = true
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "template_description" {
  type    = string
  default = "${env("template_description")}"
}

variable "vm_cpu" {
  type    = string
  default = "${env("vm_cpu")}"
}

variable "vm_default_user" {
  type    = string
  default = "${env("vm_default_user")}"
}

variable "vm_disk" {
  type    = string
  default = "${env("vm_disk")}"
}

variable "vm_id" {
  type    = string
  default = "${env("vm_id")}"
}

variable "vm_memory" {
  type    = number 
  default = "${env("vm_memory")}"
}

variable "vm_name" {
  type    = string
  default = "${env("vm_name")}"
}

source "proxmox" "build-template" {
  boot_command = ["<esc><wait>", "auto <wait>", "console-keymaps-at/keymap=fr <wait>", "console-setup/ask_detect=false <wait>", "debconf/frontend=noninteractive <wait>", "debian-installer=fr_FR <wait>", "fb=false <wait>", "install <wait>", "packer_host={{ .HTTPIP }} <wait>", "packer_port={{ .HTTPPort }} <wait>", "kbd-chooser/method=fr <wait>", "keyboard-configuration/xkb-keymap=fr <wait>", "locale=fr_FR <wait>", "netcfg/get_hostname=${var.vm_name} <wait>", "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>", "<enter><wait>"]
  boot_wait    = "10s"
  cores        = "${var.vm_cpu}"
  disks {
    disk_size         = "${var.vm_disk}"
    format            = "raw"
    storage_pool      = "${var.proxmox_vm_storage}"
    storage_pool_type = "directory"
    type              = "virtio"
  }
  http_directory           = "http"
  insecure_skip_tls_verify = true
  iso_checksum             = "${var.proxmox_iso_checksum}"
  iso_storage_pool         = "${var.proxmox_iso_storage}"
  iso_url                  = "${var.proxmox_iso_url}"
  memory                   = var.vm_memory
  network_adapters {
    bridge = "${var.proxmox_network}"
    model  = "virtio"
  }
  node                 = "${var.proxmox_node}"
  os                   = "l26"
  password             = "${var.proxmox_password}"
  proxmox_url          = "${var.proxmox_url}"
  qemu_agent           = "true"
  ssh_password         = "${var.ssh_password}"
  ssh_timeout          = "30m"
  ssh_username         = "${var.ssh_username}"
  template_description = "${var.template_description}"
  unmount_iso          = true
  username             = "${var.proxmox_username}"
  vm_id                = "${var.vm_id}"
  vm_name              = "${var.vm_name}"
}

build {
  description = "Debian 12 (Bookworm)"

  sources = ["source.proxmox.build-template"]

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_FORCE_COLOR=1", "ANSIBLE_HOST_KEY_CHECKING=False"]
    playbook_file    = "ansible/provisioning.yml"
  }

}