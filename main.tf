resource "azurerm_network_security_group" "default" {
  name                = "${var.name}-default-nsg"
  location            = var.region
  resource_group_name = var.rg

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "ICMP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "lan" {
  name                = "${var.name}-lan-nsg"
  location            = var.region
  resource_group_name = var.rg

  security_rule {
    name                       = "All"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "default" {
  count               = var.public_ip ? 1 : 0
  name                = "${var.name}-pub_ip"
  location            = var.region
  resource_group_name = var.rg
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "default" {
  name                = "${var.name}-default-nic"
  location            = var.region
  resource_group_name = var.rg

  ip_configuration {
    name                          = "${var.name}-nic-config"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip ? azurerm_public_ip.default[0].id : null
  }
}

resource "azurerm_network_interface" "lan" {
  name                 = "${var.name}-lan-nic"
  location             = var.region
  resource_group_name  = var.rg
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "${var.name}-lan-nic-config"
    subnet_id                     = var.lan_subnet
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "default" {
  network_interface_id      = azurerm_network_interface.default.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_network_interface_security_group_association" "lan" {
  network_interface_id      = azurerm_network_interface.lan.id
  network_security_group_id = azurerm_network_security_group.lan.id
}


resource "azurerm_virtual_machine" "default" {
  name                         = "${var.name}-vm"
  location                     = var.region
  resource_group_name          = var.rg
  network_interface_ids        = [azurerm_network_interface.default.id, azurerm_network_interface.lan.id]
  primary_network_interface_id = azurerm_network_interface.default.id
  vm_size                      = var.instance_size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.name}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.name
    admin_username = "ubuntu"
    custom_data    = var.cloud_init_data
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/ubuntu/.ssh/authorized_keys"
      key_data = var.ssh_key
    }
  }
  depends_on = [
    azurerm_network_interface_security_group_association.default, azurerm_network_interface_security_group_association.lan
  ]
}
