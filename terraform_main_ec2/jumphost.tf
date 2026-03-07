
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "jumphost-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_D2s_v3"

  admin_username = "vasu"
  disable_password_authentication = true
  admin_ssh_key {
   username   = "vasu"
   public_key = file("C:/Users/Saurabh/.ssh/id_rsa.pub")
}

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity.id]
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 50
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(file("install-tools.sh"))
}

