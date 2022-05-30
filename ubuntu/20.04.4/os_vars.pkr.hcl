iso_url          = "https://releases.ubuntu.com/20.04.4/ubuntu-20.04.4-live-server-amd64.iso"
iso_checksum     = "sha256:28ccdb56450e643bad03bb7bcf7507ce3d8d90e8bf09e38f6bd9ac298a98eaad"

vm_name          = "ubuntu_20.04.4"
vm_guest_os_type = "ubuntu64Guest"
vm_disk_size     = 12288
shell_scripts    = [
    "./scripts/ansible.sh",
    "./scripts/cleanup.sh"
]

ssh_username     = "ubuntu"
ssh_password     = "packer" # This password is temporary as it gets removed at the end of the template creation process.