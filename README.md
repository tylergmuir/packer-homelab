# packer-homelab
Repository of packer configs for my homelab

To create a template from the directory that has the build.pkr.hcl file:
```bash
packer build --var-file=../../vm_vars.pkr.hcl --var-file=os_vars.pkr.hcl build.pkr.hcl
```
