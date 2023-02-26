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



# Define the VM names as a variable
variable "vm_names" {
  type = list(string)
  default = [
    "vm1",
    "vm2"
  ]
}

# Create a resource group for the VMs
resource "azurerm_resource_group" "myresourcegroup" {
  name = "myresourcegroup"
  location = "eastus"
}

# Create a virtual network for the VMs
resource "azurerm_virtual_network" "mynetwork" {
  name = "mynetwork"
  address_space = ["10.0.0.0/16"]
  location = "eastus"
  resource_group_name = azurerm_resource_group.myresourcegroup.name
}

# Create a subnet for the VMs
resource "azurerm_subnet" "mysubnet" {
  name = "mysubnet"
  address_prefixes = ["10.0.1.0/24"]
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  virtual_network_name = azurerm_virtual_network.mynetwork.name
}

# Create a network interface for each VM
resource "azurerm_network_interface" "vm_nic" {
  for_each = toset(var.vm_names)

  name = "${each.value}-nic"
  location = "eastus"
  resource_group_name = azurerm_resource_group.myresourcegroup.name

  ip_configuration {
    name = "${each.value}-ipconfig"
    subnet_id = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a virtual machine for each VM
resource "azurerm_virtual_machine" "vm" {
  for_each = toset(var.vm_names)

  name = each.value
  location = "eastus"
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  network_interface_ids = [azurerm_network_interface.vm_nic[each.key].id]

  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04-LTS"
    version = "latest"
  }

  storage_os_disk {
    name = "${each.value}-osdisk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = each.value
    admin_username = "adminuser"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

    vm_size = "Standard_DS1_v2"
  # Other VM configurations
}









































# variable "vm_configurations" {
#   type = map(object({
#     location         = string
#     resource_group   = string
#     network_interface_name = string
#     size             = string
#     admin_username   = string
#     admin_password   = string
#   }))
#   default = {
#     "vm1" = {
#       location         = "eastus"
#       resource_group   = "my-resource-group"
#       network_interface_name = "my-nic1"
#       size             = "Standard_B2s"
#       admin_username   = "abhinav"
#       admin_password   = "abhinav123"
#     },
#     "vm2" = {
#       location         = "eastus"
#       resource_group   = "my-resource-group"
#       network_interface_name = "my-nic2"
#       size             = "Standard_B2s"
#       admin_username   = "abhinav"
#       admin_password   = "abhinav123"
#     }
#   }
# }

# variable "network_interface_configurations" {
#   type = map(object({
#     location         = string
#     resource_group   = string
#     subnet_name      = string
#   }))
#   default = {
#     "my-nic1" = {
#       location         = "eastus"
#       resource_group   = "my-resource-group"
#       subnet_name      = "my-subnet1"
#     },
#     "my-nic2" = {
#       location         = "eastus"
#       resource_group   = "my-resource-group"
#       subnet_name      = "my-subnet2"
#     }
#   }
# }

# resource "azurerm_network_interface" "this" {
#   for_each = var.network_interface_configurations

#   name                = each.key
#   location            = each.value.location
#   resource_group_name = each.value.resource_group

#   ip_configuration {
#     name                          = "ipconfig1"
#     subnet_id                     = azurerm_subnet.this[each.value.subnet_name].id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_subnet" "this" {
#   for_each = var.subnet_configurations

#   name                 = each.key
#   resource_group_name  = each.value.resource_group
#   virtual_network_name = azurerm_virtual_network.this[each.value.virtual_network_name].name
#   address_prefixes     = [each.value.address_prefix]
# }

# resource "azurerm_virtual_network" "this" {
#   for_each = var.virtual_network_configurations 
  
#   }
#    address_space {
#     address_prefixe = each.value.address_prefix
#   }

#   name                = each.key
#   location            = each.value.location
#   resource_group_name = each.value.resource_group
 
 
  
#   subnet {
#     name           = each.value.subnet_name
#     address_prefix = each.value.subnet_address_prefix
    
#   }


# resource "azurerm_virtual_machine" "this" {
#   for_each = var.vm_configurations

#   name                  = each.key
#   location              = each.value.location
#   resource_group_name   = each.value.resource_group
#   network_interface_ids = [azurerm_network_interface.this[each.value.network_interface_name].id]
#   vm_size               = each.value.size
#     storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }
  
#   storage_os_disk {
#     name              = "${each.key}-osdisk"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }
# }
  
























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


# variable "vm_details" {
#   type = map(object({
#     resource_group_name = string
#     name        = string
#     vm_size     = string
#     admin_username = string
#     admin_password = string
#   }))

#   default = {
#     vm1 = {
#         resource_group_name = "example"
#       name = "vm1"
#       vm_size = "Standard_B1s"
#       admin_username = "abhinav"
#       admin_password = "abhinav123"
#     }
#     vm2 = {
#         resource_group_name = "example"
#       name = "vm2"
#       vm_size = "Standard_B1s"
#       admin_username = "abhinav"
#       admin_password = "abhinav123"
#     }
#   }
# }

# resource "azurerm_resource_group" "example" {
#   name     = "example"
#   location = "westus"
# }

# resource "azurerm_network_interface" "example" {
#   for_each = var.vm_details
#   name                = "example-nic-${each.key}"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   ip_configuration {
#     name                          = "internal"
#     private_ip_address_allocation = "Dynamic"
#   }
# }

 

# resource "azurerm_virtual_machine" "example" {
#   for_each = var.vm_details
#   name                  = each.value.name
#   location              = azurerm_resource_group.example.location
#   resource_group_name   = azurerm_resource_group.example.name
#   vm_size               = each.value.vm_size
#   network_interface_ids = [azurerm_network_interface.example[each.key].id]


# storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }

# storage_os_disk {
#     name              = "${each.value.name}-os-disk"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     # managed_disk_type = each.value.disk_type
#   }


# os_profile {
#   computer_name  = each.value.name
#   admin_username = "abhinav"
#   admin_password = "abhinav123"

# }
# }
















































































# # # Azure Provider
# # terraform {
# #   required_providers {
# #     azurerm = {
# #       source  = "hashicorp/azurerm"
# #       version = "=3.0.0"
# #     }
# #   }
# # }

# # # Configure the Microsoft Azure Provider
# # provider "azurerm" {
# #   features {}
# # }

# # variable "vm_os_image" {
# #   type = string
# #   default = "UbuntuLTS"
# # }

# # variable "vm_size" {
# #   type = string
# #   default = "Standard_B2s"
# # }

# # variable "disk_type" {
# #   type = string
# #   default = "Standard_LRS"
# # }

# # variable "vms" {
# #   type = map(map(string))
# #   default = {
# #     vm1 = {
# #       name = "vm1"
# #       os_image = "UbuntuLTS"
# #       size = "Standard_B2s"
# #     },
# #     vm2 = {
# #       name = "vm2"
# #       os_image = "UbuntuLTS"
# #       size = "Standard_B2s"
# #     }
# #   }
# # }


# # resource "azurerm_resource_group" "example" {
# #   name     = "example-rg"
# #   location = "westeurope"
# # }

# # resource "azurerm_network_interface" "example" {
# #   for_each = var.vms
# #   name = "example-nic-${each.key}"
# #   location  = azurerm_resource_group.example.location
# # }
# # resource "azurerm_virtual_machine" "example" {
# #   for_each = var.vms

# #   name                  = each.value["name"]
# #   location              = azurerm_resource_group.example.location
# #   resource_group_name   = azurerm_resource_group.example.name
# #   network_interface_ids = [azurerm_network_interface.example[each.key].id]

# #   storage_os_disk {
# #     name              = "${each.value["name"]}-osdisk"
# #     caching           = "ReadWrite"
# #     create_option     = "FromImage"
# #     managed_disk_type = var.disk_type
# #   }

# #   os_profile {
# #     computer_name  = each.value["name"]
# #     admin_username = "adminuser"
# #     admin_password = "Password1234!"
# #   }

# #   os_profile_linux_config {
# #     disable_password_authentication = false
# #   }

# #   source_image_reference {
# #     publisher = "Canonical"
# #     offer     = each.value["os_image"]
# #     sku       = "20.04-LTS"
# #     version   = "latest"
# #   }

# #   hardware_profile {
# #     vm_size = each.value["size"]
# #   }
# # }

# # # resource "azurerm_network_interface" "example" {
# # #   for_each = var.vms

# # #   name                = "${each.value["name"]}-nic"
# # #   location            = azurerm_
























# variable "vm_configurations" {
#   type = map(object({
#     location         = string
#     resource_group   = string
#     network_interface_name = string
#     size             = string
#     admin_username   = string
#     admin_password   = string
#   }))
#   default = {
#     "vm1" = {
#       location         = "eastus"
#       resource_group   = "my-resource-group"
#       network_interface_name = "my-nic1"
#       size             = "Standard_B2s"
#       admin_username   = "abhinav"
#       admin_password   = "abhinav123"
#     },
#     "vm2" = {
#       location         = "eastus"
#       resource_group   = "my-resource-group"
#       network_interface_name = "my-nic2"
#       size             = "Standard_B2s"
#       admin_username   = "abhinav"
#       admin_password   = "abhinav123"
#     }
#   }
# }

# variable "network_interface_configurations" {
#   type = map(object({
#     location         = string
#     resource_group   = string
#     subnet_name      = string
#   }))
#   default = {
#     "my-nic1" = {
#       location         = "eastus"
#       resource_group   = "my-resource-group"
#       subnet_name      = "my-subnet1"
#     },
#     "my-nic2" = {
#       location         = "eastus"
#       resource_group   = "my-resource-group"
#       subnet_name      = "my-subnet2"
#     }
#   }
# }

# resource "azurerm_network_interface" "this" {
#   for_each = var.network_interface_configurations

#   name                = each.key
#   location            = each.value.location
#   resource_group_name = each.value.resource_group

#   ip_configuration {
#     name                          = "ipconfig1"
#     subnet_id                     = azurerm_subnet.this[each.value.subnet_name].id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_subnet" "this" {
#   for_each = var.subnet_configurations

#   name                 = each.key
#   resource_group_name  = each.value.resource_group
#   virtual_network_name = azurerm_virtual_network.this[each.value.virtual_network_name].name
#   address_prefixes     = [each.value.address_prefix]
# }

# resource "azurerm_virtual_network" "this" {
#   for_each = var.virtual_network_configurations 
  
 
 
#   name                = each.key
#   location            = each.value.location
#   resource_group_name = each.value.resource_group
#   address_space {
#   address_prefix      = "10.0.1.0/24"
#   }
 
  
#   subnet {
#        name           = each.value.subnet_name
#        address_prefix = each.value.subnet_address_prefix
#      }
#   }


# resource "azurerm_virtual_machine" "this" {
#   for_each = var.vm_configurations

#   name                  = each.key
#   location              = each.value.location
#   resource_group_name   = each.value.resource_group
#   network_interface_ids = [azurerm_network_interface.this[each.value.network_interface_name].id]
#   vm_size               = each.value.size
#     storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }
  
#   storage_os_disk {
#     name              = "${each.key}-osdisk"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }
# }
  






































# Azure Provider
# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "=3.0.0"
#     }
#   }
# }
      
# Configure the Microsoft Azure Provider
# provider "azurerm" {
#   features {}
# }


# variable "vm_details" {
#   type = map(object({
#     resource_group_name = string
#     name        = string
#     vm_size     = string
#     subnet_id   = string 
#     admin_username = string
#     admin_password = string
#   }))

#   default = {
#     vm1 = {
#         resource_group_name = "example"
#       name = "vm1"
#       vm_size = "Standard_B1s"
#       subnet_id = "10.0.0.0/24"
#       admin_username = "abhinav"
#       admin_password = "abhinav123"
#     }
#     vm2 = {
#         resource_group_name = "example"
#       name = "vm2"
#       vm_size = "Standard_B1s"
#       subnet_id = "10.0.0.0/24"
#       admin_username = "abhinav"
#       admin_password = "abhinav123"
#     }
#   }
# }

# resource "azurerm_resource_group" "example" {
#   name     = "example"
#   location = "westus"
# }


# resource "azurerm_network_interface" "example" {
#   for_each = var.vm_details

#   name                = "example-nic-${each.key}"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = 
#     private_ip_address_allocation = "Dynamic"
#   }
# }
# resource "azurerm_network_interface" "example" {
#   for_each = var.vm_details
#   name                = "example-nic-${each.key}"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.this[each.value.subnet_name].id
#     private_ip_address_allocation = "Dynamic"
#   }
#   }

 

# resource "azurerm_virtual_machine" "example" {
#   for_each = var.vm_details
#   name                  = each.value.name
#   location              = azurerm_resource_group.example.location
#   resource_group_name   = azurerm_resource_group.example.name
#   vm_size               = each.value.vm_size
#   network_interface_ids = [azurerm_network_interface.example[each.key].id]

# storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }

# storage_os_disk {
#     name              = "${each.value.name}-os-disk"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = each.value.disk_type
#   }


# os_profile {
#   computer_name  = each.value.name
#   admin_username = "abhinav"
#   admin_password = "abhinav123"

# }
# }
















































































# Azure Provider
# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "=3.0.0"
#     }
#   }
# }

# Configure the Microsoft Azure Provider
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
