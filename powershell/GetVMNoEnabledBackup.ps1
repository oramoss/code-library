<#
-- -----------------------------------------------------------------------------
-- =============================================================================                                
--                                 
-- FileName    : GetVMNoEnabledBackup.ps1
-- Description : This script gets a list of VMs without an enabled backup.
--                                                                              
-- =============================================================================                                 
--                                                                              
-- Change History                                                               
-- Name         Date           Description
-- Jeff Moss    24-JAN-2021    Created
-- -----------------------------------------------------------------------------
#>
#---------[Parameters]----------------------------------------------------------

$VMs = Get-AzVM
foreach ($VM in $VMs)
{
    $RecoveryServicesVaults = Get-AzRecoveryServicesVault | Where-Object { $_.Location -eq $VM.Location }
    foreach ($RecoveryServicesVault in $RecoveryServicesVaults)
    {
        $container = Get-AzRecoveryServicesBackupContainer -VaultID $RecoveryServicesVault.ID -ContainerType "AzureVM" -Status "Registered" -FriendlyName $VM.Name
        if (-NOT ($container) ) {
            $VM.Name
        }
    }
}
