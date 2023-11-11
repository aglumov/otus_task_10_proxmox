resource "local_file" "ansible_inventory" {
  filename        = "../ansible/inventory.ini"
  file_permission = 0644
  content = templatefile("./inventory.tftpl",
    {
      db_ip_address_list  = proxmox_lxc.db[*].network[0].ip
      db_vm_names         = proxmox_lxc.db[*].hostname
      app_ip_address_list = proxmox_lxc.app[*].network[0].ip
      app_vm_names        = proxmox_lxc.app[*].hostname
      lb_ip_address_list  = proxmox_lxc.lb[*].network[0].ip
      lb_vm_names         = proxmox_lxc.lb[*].hostname
    }
  )
}
