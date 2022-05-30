# Credentials
variable "vcenter_username" {
  type    = string
  description = "The username for authenticating to vCenter."
}

variable "vcenter_password" {
  type    = string
  description = "The plaintext password for authenticating to vCenter."
  sensitive = true
}

variable "ssh_username" {
  type    = string
  description = "The username to use to authenticate over SSH."
}

variable "ssh_password" {
  type    = string
  description = "The plaintext password to use to authenticate over SSH."
  sensitive = true
}

# vSphere Objects
variable "vcenter_server" {
  type    = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance."
}

variable "vcenter_datacenter" {
  type    = string
  description = "Required if there is more than one datacenter in vCenter."
}

variable "vcenter_cluster" {
  type = string
  description = "The cluster where target VM is created."
}

variable "vcenter_datastore" {
  type    = string
  description = "Required for clusters, or if the target host has multiple datastores."
}

variable "vcenter_network" {
  type    = string
  description = "The network segment or port group name to which the primary virtual network adapter will be connected."
}

variable "vcenter_folder" {
  type    = string
  description = "The VM folder in which the VM template will be created."
}

# ISO Objects
variable "iso_url" {
  type    = string
  description = "The url to retrieve the iso image"
}

variable "iso_checksum" {
  type    = string
  description = "The checksum of the ISO image."
}

# HTTP Endpoint
variable "http_directory" {
  type    = string
  description = "Directory of config files(user-data, meta-data)."
  default = "http"
}

# Virtual Machine Settings
variable "vm_name" {
  type    = string
  description = "The template vm name"
}

variable "vm_guest_os_type" {
  type    = string
  description = "The guest operating system type, also know as guestid."
}

variable "vm_cpu_cores" {
  type = number
  description = "The number of virtual CPUs cores per socket."
  default = 1
}

variable "vm_mem_size" {
  type = number
  description = "The size for the virtual memory in MB."
  default = 2048
}

variable "vm_disk_size" {
  type = number
  description = "The size for the virtual disk in MB."
}

variable "vm_disk_controller_type" {
  type = list(string)
  description = "The virtual disk controller types in sequence."
  default = ["pvscsi"]
}

variable "vm_network_card" {
  type = string
  description = "The virtual network card type."
  default = "vmxnet3"
}

variable "shell_scripts" {
  type = list(string)
  description = "A list of scripts."
  default = []
}

locals {
  buildtime = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
}

source "vsphere-iso" "linux-ubuntu-server" {
  vcenter_server = var.vcenter_server
  username = var.vcenter_username
  password = var.vcenter_password
  datacenter = var.vcenter_datacenter
  datastore = var.vcenter_datastore
  cluster = var.vcenter_cluster
  folder = var.vcenter_folder
  remove_cdrom = true
  convert_to_template = true
  guest_os_type = var.vm_guest_os_type
  notes = "Built by HashiCorp Packer on ${local.buildtime}."
  vm_name = var.vm_name
  CPUs = var.vm_cpu_cores
  RAM = var.vm_mem_size
  disk_controller_type = var.vm_disk_controller_type
  storage {
    disk_size = var.vm_disk_size
  }
  network_adapters {
    network = var.vcenter_network
    network_card = var.vm_network_card
  }
  iso_url = var.iso_url
  iso_checksum = var.iso_checksum
  http_directory = var.http_directory
  boot_wait = "5s"
  boot_command = [
    "<esc><wait><esc><wait><f6><wait><esc><wait>",
    "<bs><bs><bs><bs><bs>",
    "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
    "--- <enter>"
  ]
  ssh_password = var.ssh_password
  ssh_username = var.ssh_username
  ssh_timeout = "30m"
  #shutdown_command = "sudo cloud-init clean; sudo rm -f /etc/sudoers.d/ubuntu; shutdown now"
}

build {
  sources = ["source.vsphere-iso.linux-ubuntu-server"]
  provisioner "shell" {
    scripts = var.shell_scripts
  }
}
