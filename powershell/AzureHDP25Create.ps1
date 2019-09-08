<#
.SYNOPSIS
Author: Jeff Moss
email: jeff.moss@oramoss.com
Ver 1.0

This script creates a Hortonworks Data Platform v2.5 Sandbox VM on Azure

.DESCRIPTION
This script creates a Hortonworks Data Platform v2.5 Sandbox VM on Azure

.LINK
https://github.com/oramoss/azure/blob/master/AzureHDP25Create.ps1

#>
Login-AzureRMAccount

# Variables    
## Global
$ResourceGroupName = "oramoss_resourcegroup"
$Location = "ukwest"

## Storage
$StorageName = "oramosshdp25storage"
$StorageType = "Standard_LRS"

## Network
$InterfaceName = "oramoss_hdp25_NetworkInterface1"
$Subnet1Name = "oramoss_hdp25_subnet1"
$VNetName = "oramoss_hdp25_VNet1"
$VNetAddressPrefix = "10.0.0.0/16"
$VNetSubnetAddressPrefix = "10.0.0.0/24"
$DomainNameLabel = "oramosshdp25sandbox"

## Compute
$VMName = "HDP25VM"
$ComputerName = "hdp25vm"
$VMSize = "Standard_A4"
$OSDiskName = $VMName + "OSDisk"

# Hortonworks Sandbox VM
$Publisher = "hortonworks"
$offer = "hortonworks-sandbox"
$Skus = "sandbox25"
$version = "latest"
$Product = $offer
$name = $Skus

# Network Security setup
$NetworkSecurityGroupName = "NSG-FrontEnd"

# Resource Group
# Resource Group
Write-Host "[Start] creating $ResourceGroupName Resource Group in $Location location"
try{
    Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction Stop | Out-Null
    Write-Host "$ResourceGroupName Resource Group in $Location location already exists, skipping creation"
    }
catch{
    Write-Host "[Finish] creating $ResourceGroupName Resource Group in $Location location"
    New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location -Verbose
}

# Storage
$StorageAccount = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageName -Type $StorageType -Location $Location

# Network
$PIp = New-AzureRmPublicIpAddress -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Dynamic -DomainNameLabel $DomainNameLabel
$SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $Subnet1Name -AddressPrefix $VNetSubnetAddressPrefix
$VNet = New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Location $Location -AddressPrefix $VNetAddressPrefix -Subnet $SubnetConfig
$Interface = New-AzureRmNetworkInterface -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location -SubnetId $VNet.Subnets[0].Id -PublicIpAddressId $PIp.Id

## Get Credentials
$Credential = Get-Credential

## Setup local VM object
$VirtualMachine = New-AzureRmVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -Linux -ComputerName $ComputerName -Credential $Credential
$VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine -PublisherName $Publisher -Offer $offer -Skus $Skus -Version $version
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $Interface.Id


## Set Plan info
$VirtualMachine = Set-AzureRmVMPlan -VM $VirtualMachine -Publisher $Publisher -Product $Product -Name $name

## Set Boot Diag storage account
$VirtualMachine = Set-AzureRmVMBootDiagnostics -VM $VirtualMachine -Enable -ResourceGroupName $ResourceGroupName -StorageAccountName $StorageAccount.StorageAccountName

## Create the VM in Azure
New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VirtualMachine

# security rules for various ports
$rule1 = New-AzureRmNetworkSecurityRuleConfig -Name 8080-rule -Description "Allow 8080 Inbound" -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 8080
$rule2 = New-AzureRmNetworkSecurityRuleConfig -Name 4200-rule -Description "Allow 4200 Inbound" -Access Allow -Protocol Tcp -Direction Inbound -Priority 101 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 4200
$rule3 = New-AzureRmNetworkSecurityRuleConfig -Name 50070-rule -Description "Allow 50070 Inbound" -Access Allow -Protocol Tcp -Direction Inbound -Priority 102 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 50070
$rule4 = New-AzureRmNetworkSecurityRuleConfig -Name 21000-rule -Description "Allow 21000 Inbound" -Access Allow -Protocol Tcp -Direction Inbound -Priority 103 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 21000
$rule5 = New-AzureRmNetworkSecurityRuleConfig -Name 9995-rule -Description "Allow 9995 Inbound" -Access Allow -Protocol Tcp -Direction Inbound -Priority 104 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 9995
$rule6 = New-AzureRmNetworkSecurityRuleConfig -Name 15000-rule -Description "Allow 15000 Inbound" -Access Allow -Protocol Tcp -Direction Inbound -Priority 105 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 15000
$rule7 = New-AzureRmNetworkSecurityRuleConfig -Name 6080-rule -Description "Allow 6080 Inbound" -Access Allow -Protocol Tcp -Direction Inbound -Priority 106 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 6080
$rule8 = New-AzureRmNetworkSecurityRuleConfig -Name 8888-rule -Description "Allow 8888 Inbound" -Access Allow -Protocol Tcp -Direction Inbound -Priority 107 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 8888
$rule9 = New-AzureRmNetworkSecurityRuleConfig -Name 22-rule -Description "Allow 22 Inbound" -Access Allow -Protocol Tcp -Direction Inbound -Priority 108 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22

# add rules to network security group
$nsg = New-AzureRmNetworkSecurityGroup -Name $NetworkSecurityGroupName -ResourceGroupName $ResourceGroupName -Location $Location -SecurityRules $rule1,$rule2,$rule3,$rule4,$rule5,$rule6,$rule7,$rule8,$rule9
$SubnetConfig = Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $VNet -Name $Subnet1Name -AddressPrefix $VNetSubnetAddressPrefix -NetworkSecurityGroup $nsg
Set-AzureRmVirtualNetwork -VirtualNetwork $VNet


# Remove stuff
#Remove-AzureRmVM -Force -Name $VMName -ResourceGroupName $ResourceGroupName
#Remove-AzureRmResourceGroup -Name $ResourceGroupName -Force

