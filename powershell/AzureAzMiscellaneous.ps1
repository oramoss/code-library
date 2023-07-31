#AZ commands can be run from a command line if AZ is available or in CloudShell

# Get list of accounts including subscription ID and tenant ID
az account list

# Find list of IP addresses in use - from which, knowing the subnet range you can work out what's free
$RgName="?"
$vnetName="?"
$known_ip="?"
az network vnet check-ip-address --resource-group $RgName --name $vnetName --ip-address $known_ip

# Find list of NICs and their details (no filtering!)
az network nic list 

# Get a list of Azure Resources
Get-AzureRmResource | ft

# Get list of subscriptions
Get-AzureRmSubscription

# Set the subscription using subscription ID
Select-AzureRmSubscription -SubscriptionId xxxxx-xxxxx-xxxxxx-xxxx

# Enable accelerated networking
az account set -s "<subscription>"
az network nic update -g "<resource group of the NIC>" -n "<NIC>" --accelerated-networking true

# Get Sku/AZ availability
az vm list-skus --location francecentral --size Standard_D4ads_v5 --all --output table
