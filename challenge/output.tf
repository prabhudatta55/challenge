output "PUBLIC_IP_ADDRESS" {
 value = azurerm_virtual_machine.main.public_ip_address
 description = "The public IP address of the VM instance."
}

output "VM_NAME" {
 value = azurerm_virtual_machine.main.name
 description = "The VM instance name"
}

output "VM_ADMIN_USERNAME" {
 value = azurerm_virtual_machine.main.admin_username
 description = "The VM username to access"
}

output "MYSQL_FQDN" {
 value = azurerm_mysql_server.mysql.fqdn
 description = "Mysql server FQDN "
}
output "MYSQL_SERVER_NAME" {
 value = azurerm_mysql_server.mysql.name
 description = "Mysql server name "
}
output "MYSQL_ADMIN_LOGIN" {
 value = azurerm_mysql_server.mysql.administrator_login
 description = "Mysql server admin login username"
}
output "MYSQL_ADMIN_PASSWORD" {
 value = azurerm_mysql_server.mysql.administrator_login_password 
 description = "Mysql server admin password "
}
output "MYSQL_DATABASE_NAME" {
 value = azurerm_mysql_database.mysql.name 
 description = "Mysql server database name "
}
