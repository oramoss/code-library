# Write the header
Write-Output '"Subscription Name","Resource Group Name","Location","Resource Type","Resource Name"'
$Subscriptions = Get-AzSubscription
ForEach ($Subscription in $Subscriptions) {
  Set-AzContext $Subscription.Name | Out-null
  $Resources = Get-AzResource|Where-Object {$_.Location -NotMatch 'northeurope' -And $_.Location -NotMatch 'westeurope' -And $_.Location -NotMatch 'uksouth' -And $_.Location -NotMatch 'ukwest' -And $_.Location -NotMatch 'global' -And $_.Location -NotMatch 'europe'}
  ForEach ($Resource in $Resources) {
    $csvRecord = '"' + $Subscription.Name + '","' + `
                           $Resource.ResourceGroupName + '","' + `
                           $Resource.Location + '","' + `
                           $Resource.ResourceType + '","' + `
                           $Resource.Name + '"'
    $csvRecord
  }
}
