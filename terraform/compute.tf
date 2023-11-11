resource "proxmox_lxc" "db" {
  count        = 1
  target_node  = "lech"
  hostname     = "db${count.index}"
  vmid         = 200 + count.index
  ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged = true

  ssh_public_keys = file("~/.ssh/id_rsa.pub")

  memory = 512
  swap   = 0

  rootfs {
    storage = "tb"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip = "192.168.3.10${count.index}/24"
  }

  onboot = true
  start  = true
}

resource "proxmox_lxc" "app" {
  count        = 2
  target_node  = "lech"
  hostname     = "app${count.index}"
  vmid         = 210 + count.index
  ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged = true

  ssh_public_keys = file("~/.ssh/id_rsa.pub")

  memory = 512
  swap   = 0

  rootfs {
    storage = "tb"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip = "192.168.3.11${count.index}/24"
    #    ip = "dhcp"
    #    hwaddr = "c2:2e:7f:e7:b5:1${count.index}"
  }

  onboot = true
  start  = true
}

resource "proxmox_lxc" "lb" {
  count        = 1
  target_node  = "lech"
  hostname     = "lb${count.index}"
  vmid         = 220 + count.index
  ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  unprivileged = true

  ssh_public_keys = file("~/.ssh/id_rsa.pub")

  memory = 512
  swap   = 0

  rootfs {
    storage = "tb"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip = "192.168.3.12${count.index}/24"
  }

  onboot = true
  start  = true
}
