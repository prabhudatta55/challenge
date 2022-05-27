#Define the Backend
terraform {
  backend "azurerm" { }
}

#Define the Azure Provider
provider "azurerm" {
  features {}
}

#Creating the Resource Group
resource "azurerm_resource_group" "azure-stack-rs" {
  name     = "${var.prefix}-resources"
  location = "West Europe"
}

#Creating Azure Virtual network
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.azure-stack-rs.location
  resource_group_name = azurerm_resource_group.azure-stack-rs.name
}

#Creating Azure subnet
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.azure-stack-rs.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

#Creating Network Interface
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.azure-stack-rs.location
  resource_group_name = azurerm_resource_group.azure-stack-rs.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Creating Azure azurerm_availability_set
resource "azurerm_availability_set" "web_availabilty_set" {
  name                = "web_availabilty_set-aset"
  location            = azurerm_resource_group.azure-stack-rs.location
  resource_group_name = azurerm_resource_group.azure-stack-rs.name

}

#Creating a virtual machine with provisioner to execute a node application
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.azure-stack-rs.location
  resource_group_name   = azurerm_resource_group.azure-stack-rs.name
  network_interface_ids = [azurerm_network_interface.main.id]
  availability_set_id = azurerm_availability_set.web_availabilty_set.id
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.version
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "development"
  }
  provisioner "file" {
    source      = "app/project.js"
    destination = "/usr/local/project.js"
  }
 provisioner "remote-exec" {
    inline = [
      "chmod +x /usr/local/project.js",
      "node /usr/local/project.js args",
    ]
  }
}

#Creating Mysql Server for DB layer
resource "azurerm_mysql_server" "db-layer" {
  name                = "prb-mysqlserver"
  location            = azurerm_resource_group.azure-stack-rs.location
  resource_group_name = azurerm_resource_group.azure-stack-rs.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = var.sku_name
  storage_mb = var.storage_mb
  version    = var.db_version

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

#Creating a user defined mysql database
resource "azurerm_mysql_database" "mydb" {
  name                = "projdb"
  resource_group_name = azurerm_resource_group.azure-stack-rs.name
  server_name         = azurerm_mysql_server.db-layer.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}