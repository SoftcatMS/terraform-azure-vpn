resource "azurerm_resource_group" "rg-vpn-test-basic" {
  name     = "rg-test-vpn-basic-resources"
  location = "UK South"
}


module "vnet" {
  source              = "github.com/SoftcatMS/azure-terraform-vnet"
  vnet_name           = "vnet-test-vpn-basic"
  resource_group_name = azurerm_resource_group.rg-vpn-test-basic.name
  address_space       = ["10.3.0.0/16"]
  subnet_prefixes     = ["10.3.1.0/26"]
  subnet_names        = ["GatewaySubnet"]

  tags = {
    environment = "test"
    engineer    = "ci/cd"
  }

  depends_on = [azurerm_resource_group.rg-vpn-test-basic]
}

module "simple" {
  source = "../../"

  resource_group_name  = azurerm_resource_group.rg-vpn-test-basic.name
  location             = azurerm_resource_group.rg-vpn-test-basic.location
  virtual_network_name = module.vnet.vnet_name
  gw_subnet_name       = "GatewaySubnet"
  vpn_gateway_name     = "vpn-test-basic-gw01"
  gateway_type         = "Vpn"


  # local network gateway connection
  local_networks = [
    {
      local_gw_name         = "onpremise"
      local_gateway_address = "8.8.8.8"
      local_address_space   = ["10.1.0.0/24"]
      shared_key            = "aSh4redS3kret!"
    },
  ]


  tags = {
    environment = "test"
    engineer    = "ci/cd"
  }

  depends_on = [module.vnet]


}
