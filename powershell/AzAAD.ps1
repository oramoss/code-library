//Get User by Object id:
Get-AzureADObjectByObjectId -ObjectIds 12345678-1234-1234-1234-123456789012
Get-AzureADObjectByObjectId -ObjectIds <Object ID 1>, <Object ID 2>
Get-AzureADServicePrincipal -SearchString "???"

//Get User Object by name:
Get-AzureADUser -SearchString "???"

# Install AzureAD
# Elevated command prompt
Install-Module MSOnline