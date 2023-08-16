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
module "openai" {
  source              = "Azure/openai/azurerm"
  version             = "0.1.1"
  account_name        = "${var.environment}oaitfjpdemo"
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
      name          = "ada"
      model_format  = "OpenAI"
      model_name    = "text-embedding-ada-002"
      model_version = "2"
      scale_type    = "Standard"
    },
  }
  depends_on = [
    azurerm_resource_group.oai_rg
  ]
}
