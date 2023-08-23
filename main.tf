terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0"
    }
  }

  # Update this block with the location of your terraform state file
  backend "azurerm" {
    resource_group_name  = "TFState"
    storage_account_name = "tfstatejp"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

# Define any Azure resources to be created here. A simple resource group is shown here as a minimal example.
resource "azurerm_resource_group" "oai_rg" {
  name     = var.resource_group_name
  location = var.location
}


# Define an openai resource
resource "azurerm_cognitive_account" "example" {
  name                          = "${var.environment}oaitfjpexample"
  location                      = azurerm_resource_group.oai_rg.location
  resource_group_name           = azurerm_resource_group.oai_rg.name
  kind                          = "OpenAI"
  sku_name                      = "S0"
  public_network_access_enabled = true
  custom_subdomain_name         = "example-openai2"

  #define tags
  tags = {
    environment = var.environment
  }

  depends_on = [
    azurerm_resource_group.oai_rg
  ]
}

# define openai deployment
resource "azurerm_cognitive_deployment" "example" {
  name                 = "example-cd"
  cognitive_account_id = azurerm_cognitive_account.example.id
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo"
    version = "0301"
  }

  scale {
    type = "Standard"
  }
}
