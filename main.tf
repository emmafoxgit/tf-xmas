terraform {
  cloud {
    organization = "emmafoxorg"
    ## Required for Terraform Enterprise; Defaults to app.terraform.io for Terraform Cloud
    hostname = "app.terraform.io"

    workspaces {
      names = ["emmaapi"]
    }
  }
}

resource "azurerm_resource_group" "funcexample" {
  name     = "azure-functions-cptest-rg"
  location = "West Europe"
}

resource "azurerm_storage_account" "funcexample" {
  name                     = "zzzfunctionsapptestsa"
  resource_group_name      = azurerm_resource_group.funcexample.name
  location                 = azurerm_resource_group.funcexample.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "example" {
  name                = "azure-functions-test-service-plan"
  location            = azurerm_resource_group.funcexample.location
  resource_group_name = azurerm_resource_group.funcexample.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "example" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.funcexample.location
  resource_group_name        = azurerm_resource_group.funcexample.name
  app_service_plan_id        = azurerm_app_service_plan.funcexample.id
  storage_account_name       = azurerm_storage_account.funcexample.name
  storage_account_access_key = azurerm_storage_account.funcexample.primary_access_key
}
