<#
.SYNOPSIS
Author: Jeff Moss
email: jeff.moss@eon.com
Ver 1.0

.DESCRIPTION
This script deploys a resource group template on azure to create a bunch of resources.
Copied from a Microsoft example somewhere and adjusted for E.On subscription use.

#>

param (
    #[Parameter(Mandatory)]
    #The subscription id where the template will be deployed.
    [string]$SubscriptionId = "BootsInternationalLimited-Non-Production",  

    #[Parameter(Mandatory)]
    #The resource group where the template will be deployed. Can be the name of an existing or a new resource group.
    [string]$ResourceGroupName = "Boots-International-GBATH-NE-DEV-rg", 

    #Optional, a resource group location. If specified, will try to create a new resource group in this location. If not specified, assumes resource group is existing.
    [string]$ResourceGroupLocation = "North Europe", 

    #The deployment name.
    #[Parameter(Mandatory)]
    [string]$DeploymentName = "aznelgbitdodb02",    

    #Path to the template file.
    [string]$TemplateFilePath = "C:\data\git\azure\BootsDeployLinuxDEVOEL75.json",  

    #Path to the parameters file.
    [string]$ParametersFilePath = "C:\data\git\azure\BootsDeployLinuxDEVOEL75.parameters.json"
)

$ErrorActionPreference = "Stop"

# Login to Azure and select subscription
Write-Output "Logging in"
Login-AzureRmAccount
Write-Output "Selecting subscription '$SubscriptionId'"
Select-AzureRmSubscription -SubscriptionID $SubscriptionId

# Create or check for existing resource group
$resourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if ( -not $ResourceGroup ) {
    Write-Output "Could not find resource group '$ResourceGroupName' - will create it"
    if ( -not $ResourceGroupLocation ) {
        $ResourceGroupLocation = Read-Host -Prompt 'Enter location for resource group'
    }
    Write-Output "Creating resource group '$ResourceGroupName' in location '$ResourceGroupLocation'"
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
}
else {
    Write-Output "Using existing resource group '$ResourceGroupName'"
}

# Start the deployment
Write-Output "Starting deployment"
if ( Test-Path $ParametersFilePath ) {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFilePath -TemplateParameterFile $ParametersFilePath
}
else {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFilePath
}
