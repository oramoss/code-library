<#
-- -----------------------------------------------------------------------------
-- =============================================================================                                
--                                 
-- FileName    : GetStorageAccountsSecureTransferRequired.ps1
-- Description : This script gets a list of storage accounts which require
--               Secure Transfer Required enabling.
--                                                                              
-- =============================================================================                                 
--                                                                              
-- Change History                                                               
-- Name         Date           Description
-- Jeff Moss    24-JAN-2021    Created
-- -----------------------------------------------------------------------------
#>
#---------[Parameters]----------------------------------------------------------

Get-AzStorageAccount | where {$_.EnableHttpsTrafficOnly -eq $False}
