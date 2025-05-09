resource "random_integer" "vm_app_id" {
  min = 1
  max = 1000
}

resource "azurerm_linux_virtual_machine" "vm_app" {
  name                = "lnx0${random_integer.vm_app_id.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2as_v2"

  admin_username                  = var.vm_username
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.nic_main.id,
  ]

  priority        = "Spot"
  eviction_policy = "Deallocate"

  admin_ssh_key {
    username   = var.vm_username
    public_key = azapi_resource_action.ssh_key_pair.output.publicKey
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
