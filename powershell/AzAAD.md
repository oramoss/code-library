//Connect to Azure AD
Connect-AzureAD

//Get User by Object id:
//Get-AzureADObjectByObjectId -ObjectIds <Object ID 1>, <Object ID 2>
Get-AzureADObjectByObjectId -ObjectIds d17b1097-3824-40f3-ae2e-9bf2c36c7caf

//Get Service Principal by search string
Get-AzureADServicePrincipal -SearchString "d17b1097-3824-40f3-ae2e-9bf2c36c7caf"

//Get Enterprise App
Get-AzureADApplication -Filter "DisplayName eq '85059264bf72a35ea3abf8e960b8f892e5d1cd759db9d3fe93d9503b23fa825f'"
Get-AzureADApplication -Filter "AppId eq 'd17b1097-3824-40f3-ae2e-9bf2c36c7caf'"
Get-AzureADApplication -SearchString "85059264bf72a35ea3abf8e960b8f892e5d1cd759db9d3fe93d9503b23fa825f"
Get-AzureADServicePrincipal -SearchString "85059264bf72a35ea3abf8e960b8f892e5d1cd759db9d3fe93d9503b23fa825f" | Select DisplayName,Homepage,ObjectID,AppDisplayName,PublisherName,ServicePrincipalType
Get-AzureADServicePrincipal -SearchString "2a4d218177ed6ed43aa3366162957144f56de40c903a868409324c2aaaad7628" | Format-List -Property *

//Get User Object by name:
Get-AzureADUser -SearchString "d17b1097-3824-40f3-ae2e-9bf2c36c7caf"

