# Gets a list of VMs and their backup registrations
$VMs = Get-AzVM
foreach ($VM in $VMs)
{
    "VM: " + $VM.Name
    $RecoveryServicesVaults = Get-AzRecoveryServicesVault
    foreach ($RecoveryServicesVault in $RecoveryServicesVaults)
    {
                Get-AzRecoveryServicesBackupContainer -VaultID $RecoveryServicesVault.ID -ContainerType "AzureVM" -Status "Registered" -FriendlyName $VM.Name
    }
}
