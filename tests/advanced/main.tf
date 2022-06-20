resource "azurerm_resource_group" "rg-vpn-test-advanced" {
  name     = "rg-test-vpn-advanced-resources"
  location = "UK South"
}


module "vnet1" {
  source              = "github.com/SoftcatMS/azure-terraform-vnet"
  vnet_name           = "vnet1-test-vpn1-advanced"
  resource_group_name = azurerm_resource_group.rg-vpn-test-advanced.name
  address_space       = ["10.3.0.0/16"]
  subnet_prefixes     = ["10.3.1.0/24", "10.3.2.0/26"]
  subnet_names        = ["subnet1", "GatewaySubnet"]

  tags = {
    environment = "test"
    engineer    = "ci/cd"
  }

  depends_on = [azurerm_resource_group.rg-vpn-test-advanced]
}


module "vnet2" {
  source              = "github.com/SoftcatMS/azure-terraform-vnet"
  vnet_name           = "vnet2-test-vpn2-advanced"
  resource_group_name = azurerm_resource_group.rg-vpn-test-advanced.name
  address_space       = ["10.4.0.0/16"]
  subnet_prefixes     = ["10.4.1.0/24", "10.4.2.0/26"]
  subnet_names        = ["subnet1", "GatewaySubnet"]

  tags = {
    environment = "test"
    engineer    = "ci/cd"
  }

  depends_on = [azurerm_resource_group.rg-vpn-test-advanced]
}

module "simple1" {
  source = "../../"

  name                = "vpn1-test-advanced"
  resource_group_name = azurerm_resource_group.rg-vpn-test-advanced.name
  location            = azurerm_resource_group.rg-vpn-test-advanced.location
  subnet_id           = module.vnet1.vnet_subnets[1]
  sku                 = "VpnGw1AZ"

  tags = {
    environment = "test"
    engineer    = "ci/cd"
  }

  local_networks = [
    {
      name            = "onpremise"
      gateway_address = "8.8.8.8"
      address_space = [
        "10.3.1.0/24"
      ]
      shared_key = "TESTING"
      ipsec_policy = {
        dh_group         = "DHGroup2"
        ike_encryption   = "AES256"
        ike_integrity    = "SHA256"
        ipsec_encryption = "AES256"
        ipsec_integrity  = "SHA256"
        pfs_group        = "PFS24"
        sa_datasize      = "102400000"
        sa_lifetime      = "3600"
      }
    },
  ]
}

module "simple2" {
  source = "../../"

  name                = "vpn2-test-advanced"
  resource_group_name = azurerm_resource_group.rg-vpn-test-advanced.name
  location            = azurerm_resource_group.rg-vpn-test-advanced.location
  subnet_id           = module.vnet2.vnet_subnets[1]
  sku                 = "VpnGw2AZ"

  tags = {
    environment = "test"
    engineer    = "ci/cd"
  }

  local_networks = [
    {
      name            = "onpremise"
      gateway_address = "8.8.8.8"
      address_space = [
        "10.4.1.0/24"
      ]
      shared_key = "TESTING"
      ipsec_policy = {
        dh_group         = "DHGroup2"
        ike_encryption   = "AES256"
        ike_integrity    = "SHA256"
        ipsec_encryption = "AES256"
        ipsec_integrity  = "SHA256"
        pfs_group        = "PFS24"
        sa_datasize      = "102400000"
        sa_lifetime      = "3600"
      }
    },
  ]
}
