resource "random_integer" "vm_llm_id" {
  min = 1
  max = 1000
}

resource "azurerm_linux_virtual_machine" "vm_llm_spot" {
  name                = "lnx0${random_integer.vm_llm_id.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_NV4as_v4"

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

resource "azurerm_dev_test_global_vm_shutdown_schedule" "example" {
  virtual_machine_id = azurerm_linux_virtual_machine.vm_llm_spot.id
  location           = azurerm_resource_group.rg.location
  enabled            = var.vm_autoshutdown_enabled

  daily_recurrence_time = "2330"
  // for timezone settings = https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/
  timezone = "Romance Standard Time"

  notification_settings {
    enabled         = var.vm_autoshutdown_notification_enabled
    time_in_minutes = "60"
    webhook_url     = var.vm_autoshutdown_webhook
  }
}
