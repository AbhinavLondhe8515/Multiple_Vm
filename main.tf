# Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}


variable "vm_details" {
  type = map(object({
    resource_group_name = string
    name        = string
    vm_size     = string
    admin_username = string
    admin_password = string
  }))

  default = {
    vm1 = {
        resource_group_name = "example"
      name = "vm1"
      vm_size = "Standard_B1s"
      admin_username = "abhinav"
      admin_password = "abhinav123"
    }
    vm2 = {
        resource_group_name = "example"
      name = "vm2"
      vm_size = "Standard_B1s"
      admin_username = "abhinav"
      admin_password = "abhinav123"
    }
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example"
  location = "westus"
}

resource "azurerm_network_interface" "example" {
  for_each = var.vm_details
  name                = "example-nic-${each.key}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  ip_configuration {
    name                          = "internal"
   
    private_ip_address_allocation = "Dynamic"
  }
  
  }
  
  resource "azurerm_subnet" "subnet" {
   subnet_id                      = azurerm_subnet.subnet.id


}

 

resource "azurerm_virtual_machine" "example" {
  for_each = var.vm_details
  name                  = each.value.name
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  vm_size               = each.value.vm_size
  network_interface_ids = [azurerm_network_interface.example[each.key].id]

storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

storage_os_disk {
    name              = "${each.value.name}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
#     managed_disk_type = each.value.disk_type
  }


os_profile {
  computer_name  = each.value.name
  admin_username = "abhinav"
  admin_password = "abhinav123"

}
}
















































































# # Azure Provider
# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "=3.0.0"
#     }
#   }
# }

# # Configure the Microsoft Azure Provider
# provider "azurerm" {
#   features {}
# }

# variable "vm_os_image" {
#   type = string
#   default = "UbuntuLTS"
# }

# variable "vm_size" {
#   type = string
#   default = "Standard_B2s"
# }

# variable "disk_type" {
#   type = string
#   default = "Standard_LRS"
# }

# variable "vms" {
#   type = map(map(string))
#   default = {
#     vm1 = {
#       name = "vm1"
#       os_image = "UbuntuLTS"
#       size = "Standard_B2s"
#     },
#     vm2 = {
#       name = "vm2"
#       os_image = "UbuntuLTS"
#       size = "Standard_B2s"
#     }
#   }
# }


# resource "azurerm_resource_group" "example" {
#   name     = "example-rg"
#   location = "westeurope"
# }

# resource "azurerm_network_interface" "example" {
#   for_each = var.vms
#   name = "example-nic-${each.key}"
#   location  = azurerm_resource_group.example.location
# }
# resource "azurerm_virtual_machine" "example" {
#   for_each = var.vms

#   name                  = each.value["name"]
#   location              = azurerm_resource_group.example.location
#   resource_group_name   = azurerm_resource_group.example.name
#   network_interface_ids = [azurerm_network_interface.example[each.key].id]

#   storage_os_disk {
#     name              = "${each.value["name"]}-osdisk"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = var.disk_type
#   }

#   os_profile {
#     computer_name  = each.value["name"]
#     admin_username = "adminuser"
#     admin_password = "Password1234!"
#   }

#   os_profile_linux_config {
#     disable_password_authentication = false
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = each.value["os_image"]
#     sku       = "20.04-LTS"
#     version   = "latest"
#   }

#   hardware_profile {
#     vm_size = each.value["size"]
#   }
# }

# # resource "azurerm_network_interface" "example" {
# #   for_each = var.vms

# #   name                = "${each.value["name"]}-nic"
# #   location            = azurerm_
