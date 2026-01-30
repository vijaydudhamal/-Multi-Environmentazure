data "azurerm_resource_group_name" "rg" {
    name = var.resource_group_name 
}

data "azurerm_resource_group_location" "location" {
    location = var.azurerm_resource_group_location 
}

resource "azurerm_network_security_group" "sg" {
    name = "sg-${var.env_prefix}"
    resource_group_name = data.azurerm_resource_group.rg
    location = data.azurerm_resource_group.location

    security_rule = {
        name = "allow SSH"
        priority = "100"
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"

        name = "allow ports"
        priority = "101"
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "1000-15000"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }

    tags = merge(var.common_tags,{
        environment = "var.en_prefix"
    })
     
}

# Associate the NSG with the Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}



