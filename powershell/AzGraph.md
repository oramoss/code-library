
#get graph object id

$graph = Get-AzureADServicePrincipal -Filter "AppId eq '00000003-0000-0000-c000-000000000000'"
$graph

ObjectId                             AppId                                DisplayName
--------                             -----                                -----------
3d569684-4977-4413-ad88-adbaf35a5984 00000003-0000-0000-c000-000000000000 Microsoft Graph

#added example permission for TGP-uks-DevTest-SAS-api

$groupReadPermission = $graph.AppRoles | where Value -Like "Group.Read.All" | Select-Object -First 1 
$msi = Get-AzureADServicePrincipal -ObjectId b4e1dcbc-9eb8-4a4a-bc9d-6635795c396a 
New-AzureADServiceAppRoleAssignment -Id $groupReadPermission.Id -ObjectId $msi.ObjectId -PrincipalId $msi.ObjectId -ResourceId $graph.ObjectId

#get assigned permissions in graph

get-AzureADServiceAppRoleAssignment -ObjectId 3d569684-4977-4413-ad88-adbaf35a5984

ObjectId                                    ResourceDisplayName PrincipalDisplayName
--------                                    ------------------- --------------------
etc...

#remove assigned permission for TGP-uks-DevTest-SAS-api
remove-AzureADServiceAppRoleAssignment -ObjectId b4e1dcbc-9eb8-4a4a-bc9d-6635795c396a -AppRoleAssignmentId vNzhtLieSkq8nWY1eVw5amRG4na7vLVLsHJc1m8g7YU

#get assigned permissions in graph again
get-AzureADServiceAppRoleAssignment -ObjectId 3d569684-4977-4413-ad88-adbaf35a5984

#above ID no longer returned in output
