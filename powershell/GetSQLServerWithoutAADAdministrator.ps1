<#
-- -----------------------------------------------------------------------------
-- =============================================================================                                
--                                 
-- FileName    : GetSQLServerWithoutAADAdministrator.ps1
-- Description : This script gets a list of SQL Servers without a configured
--               AAD Administrator.
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
    $ADAdmin = Get-AzSqlServerActiveDirectoryAdministrator -ServerName $sqlserver.Name -ResourceGroupName $sqlserver.ResourceGroupName
    if ($ADAdmin.DisplayName -eq "") {
      $sqlserver.Name
    }
}
