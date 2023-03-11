output "vm" {
  description = "The created VM as an object with all of it's attributes. This was created using the azurerm_virtual_machine resource."
  value       = azurerm_virtual_machine.default
}

output "nic" {
  description = "The created NIC as an object with all of it's attributes. This was created using the azurerm_network_interface resource."
  value       = azurerm_network_interface.default
}

output "lan_nic" {
  description = "The created NIC as an object with all of it's attributes. This was created using the azurerm_network_interface resource."
  value       = azurerm_network_interface.lan
}

output "public_ip" {
  description = "The public IP and all of it's attributes"
  value       = var.public_ip ? azurerm_public_ip.default[0] : null
}
