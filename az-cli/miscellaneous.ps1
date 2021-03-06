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

# Set the subscription
az account set --subscription <subscription name or id>

# List editions for sql db in a location
az sql db list-editions -l uksouth -o table
