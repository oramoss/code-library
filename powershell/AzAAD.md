//Get User by Object id:
Get-AzureADObjectByObjectId -ObjectIds 5fcb88bc-e680-4857-9780-b897301f58b5
Get-AzureADObjectByObjectId -ObjectIds <Object ID 1>, <Object ID 2>
Get-AzureADServicePrincipal -SearchString "???"

//Get User Object by name:
Get-AzureADUser -SearchString "???"

# Install AzureAD
# Elevated command prompt
Install-Module MSOnline