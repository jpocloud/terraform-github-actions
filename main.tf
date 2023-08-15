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
<<<<<<< HEAD
    storage_account_name = "tfstatejp"
=======
    storage_account_name = "terraformgithubactions"
>>>>>>> e9ffa97ab5e928d6aab2c9258648c75348a4b31d
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

module "openai" {
  source              = "Azure/openai/azurerm"
  version             = "0.1.1"
  resource_group_name = azurerm_resource_group.oai_rg.name
  location            = azurerm_resource_group.oai_rg.location

  deployment = {
    "chat_model" = {
      name          = "gpt-35-turbo"
      model_format  = "OpenAI"
      model_name    = "gpt-35-turbo"
      model_version = "0301"
      scale_type    = "Standard"
    },
    "embedding_model" = {
      name          = "text-embedding-ada-002"
      model_format  = "OpenAI"
      model_name    = "text-embedding-ada-002"
      model_version = "2"
      scale_type    = "Standard"
    },
  }
  depends_on = [
    azurerm_resource_group.this,
    module.vnet
  ]
}
