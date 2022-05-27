variable "prefix" {
  default = "tfazure"
}

variable "publisher" {
    default = "Canonical"
}
variable "offer" {
    default = "UbuntuServer"
}
variable "sku" {
    default = "16.04-LTS"
}
variable "vm_version" {
    default = "latest"
}

variable "db_sku_name" {
    default = "GP_Gen5_2"
}
variable "db_storage_mb" {
    default = "5120"
}
variable "db_version" {
    default = "5.7"
}
