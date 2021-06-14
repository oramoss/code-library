<#
-- -----------------------------------------------------------------------------
-- =============================================================================                                
--                                 
-- FileName    : GetDatabasesByServer.ps1
-- Description : This script gets a list of databases by server for the current
--               subscription.
--                                                                              
-- =============================================================================                                 
--                                                                              
-- Change History                                                               
-- Name         Date           Description
-- Jeff Moss    24-JAN-2021    Created
-- -----------------------------------------------------------------------------
#>
#---------[Parameters]----------------------------------------------------------

$sqlservers = Get-AzResource -ResourceType Microsoft.Sql/servers
foreach ($sqlserver in $sqlservers)
 {
     $sqlserver.Name
     $databases = Get-AzResource -ResourceType Microsoft.Sql/servers/databases|Where-Object {$_.Name -notlike "*master"}|Where-Object {$_.Name -like $sqlserver.Name + "/*"}
     "Database Count:" + $databases.Count
     "Databases…"
     foreach ($database in $databases)
      {
      ">>>" + $database.Name
      }
 }
