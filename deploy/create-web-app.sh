#!/bin/bash

 sudo apt-get update
      sudo apt-get install nasm -y
      sudo apt-get install xorriso -y
      sudo apt-get install git -y
      sudo apt-get install vim -y
      sudo apt-get install -y qemu
      sudo apt-get install -y curl
      
curl -L https://aka.ms/InstallAzureCli | bash
exec -l $SHELL

gitrepo=https://github.com/IvanCaro/GoCd_PoC
token=a52f577a45c539dac0bb8b66e7ac28417add1aff
webappname=web-app-bot
resourceGroup=INT_ResourceGroup

# Create a resource group.
az group delete -n $resourceGroup --yes -y

# Create a resource group.
az group create --location westeurope --name $resourceGroup

# Create an App Service plan in `FREE` tier.
az appservice plan create --name $webappname --resource-group $resourceGroup --sku FREE

# Create a web app.
az appservice web create --name $webappname --resource-group $resourceGroup --plan $webappname --runtime "node|6.10"

# Configure continuous deployment from GitHub. 
# --git-token parameter is required only once per Azure account (Azure remembers token).
az appservice web source-control config --name $webappname --resource-group $resourceGroup \
--repo-url $gitrepo --branch master --git-token $token

# Add appSettings to the node site (process.env.VARIANLE)
az appservice web config appsettings update --settings dbuser="<database user>" --name $webappname --resource-group $resourceGroup

# Browse to the web app.
az appservice web browse --name $webappname --resource-group $resourceGroup


