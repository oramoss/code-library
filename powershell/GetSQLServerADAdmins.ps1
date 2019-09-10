# Gets a list of SQL Servers and for each one, identifies the AD Administrator
$sqlservers = Get-AzResource -ResourceType Microsoft.Sql/servers
foreach ($sqlserver in $sqlservers)
{
    $sqlserver.Name
    $ADAdmin = Get-AzureRmSqlServerActiveDirectoryAdministrator -ServerName $sqlserver.Name -ResourceGroupName $sqlserver.ResourceGroupName
    "AD Administrator:" + $ADAdmin.DisplayName + "/" + $ADAdmin.ObjectId
}
