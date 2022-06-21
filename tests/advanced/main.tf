resource "azurerm_resource_group" "rg-vpn-test-advanced" {
  name     = "rg-test-vpn-advanced-resources"
  location = "UK South"
}


module "vnet1" {
  source              = "github.com/SoftcatMS/azure-terraform-vnet"
  vnet_name           = "vnet1-test-vpn1-advanced"
  resource_group_name = azurerm_resource_group.rg-vpn-test-advanced.name
  address_space       = ["10.3.0.0/16"]
  subnet_prefixes     = ["10.3.1.0/26"]
  subnet_names        = ["GatewaySubnet"]

  tags = {
    environment = "test"
    engineer    = "ci/cd"
  }

  depends_on = [azurerm_resource_group.rg-vpn-test-advanced]
}


module "advanced1" {
  source = "../../"

  resource_group_name  = azurerm_resource_group.rg-vpn-test-advanced.name
  location             = azurerm_resource_group.rg-vpn-test-advanced.location
  virtual_network_name = module.vnet1.vnet_name
  gw_subnet_name       = "GatewaySubnet"
  vpn_gateway_name     = "vpn1-test-advanced-gw01"
  gateway_type         = "Vpn"


  # local network gateway connection
  local_networks = [
    {
      local_gw_name         = "onpremise"
      local_gateway_address = "8.8.8.8"
      local_address_space   = ["10.4.0.0/24"]
      shared_key            = "aSh4redS3kret!"
    },
  ]


  tags = {
    environment = "test"
    engineer    = "ci/cd"
  }

  depends_on = [module.vnet1]

}

