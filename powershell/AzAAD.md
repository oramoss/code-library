//Get User by Object id:
Get-AzureADObjectByObjectId -ObjectIds 378236e9-854e-401a-8dac-fbfd6c8db7ac
Get-AzureADObjectByObjectId -ObjectIds <Object ID 1>, <Object ID 2>
Get-AzureADServicePrincipal -SearchString "???"

//Get User Object by name:
Get-AzureADUser -SearchString "???"

# Install AzureAD
# Elevated command prompt
Install-Module MSOnline