[System.Collections.Generic.List[PSObject]]$report = @()
$subs = Get-AzSubscription # | Where-Object {$_.State -eq 'Enabled'}
foreach ($sub in $subs) {
  Set-AzContext -SubscriptionObject $sub | Out-Null
  $vms = Get-AzVM
  foreach ($vm in $vms) {
    $info = "" | Select-Object SubscriptionName, SubscriptionId, ResourceGroupName, Name, Location, VmSize, OSType, NIC, ProvisioningState, Zones, Publisher, Offer, SKU, version
    $info.SubscriptionName = Get-AzContext|Select Name
    $info.SubscriptionId = $sub.SubscriptionId
    $info.ResourceGroupName = $vm.ResourceGroupName
    $info.Name = $vm.Name
    $info.Location = $vm.Location
    $info.VmSize = $vm.hardwareProfile.VmSize
    $info.OSType = $vm.storageProfile.osDisk.osType
    $info.NIC = $vm.networkProfile.networkInterfaces.id -replace '.*/'
    $info.ProvisioningState = $vm.ProvisioningState
    $info.Zones = ($vm.Zones -join ",")
    $info.Publisher = $vm.StorageProfile.ImageReference.Publisher
    $info.Offer = $vm.StorageProfile.ImageReference.Offer
    $info.SKU = $vm.StorageProfile.ImageReference.SKU
    $info.version = $vm.StorageProfile.ImageReference.version  
    $report.Add($info)
   }
 }
$report | Export-CSV "AzVMs.csv" -NoTypeInformation -Append

