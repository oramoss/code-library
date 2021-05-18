//Get User by Object id:
Connect-AzureAD
Get-AzureADObjectByObjectId -ObjectIds b0c63b36-29a4-4842-a31b-fc25695676df
Get-AzureADObjectByObjectId -ObjectIds <Object ID 1>, <Object ID 2>
Get-AzureADServicePrincipal -SearchString "???"

//Get User Object by name:
Get-AzureADUser -SearchString "???"

# Install AzureAD
# Elevated command prompt
Install-Module MSOnline