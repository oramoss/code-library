//Get User by Object id:
Get-AzureADObjectByObjectId -ObjectIds b7beeb60-2cab-4bc0-9bc3-b902154d46f3
Get-AzureADObjectByObjectId -ObjectIds <Object ID 1>, <Object ID 2>
Get-AzureADServicePrincipal -SearchString "???"

//Get User Object by name:
Get-AzureADUser -SearchString "???"

# Install AzureAD
# Elevated command prompt
Install-Module MSOnline