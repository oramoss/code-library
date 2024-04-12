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

# AZ DevOps
az devops configure --defaults organization=https://dev.azure.com/rev-log
az devops security group membership list --id "[IaC]\Contributors"
az devops security group membership add --group-id "[IaC]\Contributors" --member-id [TEAM FOUNDATION]\\RLG-DELG-LAAD-AZ-OrderManagement-Engineer

# Upload ssh key to key vault secret
az keyvault secret set –vault-name <name of key vault> –name <name of secret> –file <private ssh key > –encoding ascii

# https://www.danielstechblog.io/trigger-an-on-demand-azure-policy-compliance-evaluation-scan/
# Trigger a policy scan for current sub
az policy state trigger-scan
# Trigger a policy scan for current sub and RG
az policy state trigger-scan --resource-group resource-group-name

# Decompile bicep - convert json to bicep file
az bicep decompile --file main.json
