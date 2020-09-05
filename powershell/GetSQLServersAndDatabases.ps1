# Gets a list of SQL Servers and for each one, lists out how many databases are on that server and their names
# It does not include the master database.
$sqlservers = Get-AzResource -ResourceType Microsoft.Sql/servers
foreach ($sqlserver in $sqlservers)
{
    $sqlserver.Name
    $databases = Get-AzResource -ResourceType Microsoft.Sql/servers/databases|Where-Object {$_.Name -notlike "*master"}|Where-Object {$_.Name -like $sqlserver.Name + "/*"}
	"Database Count:" + $databases.Count
	"Databases..."
	">>>" + $databases.Name
}
