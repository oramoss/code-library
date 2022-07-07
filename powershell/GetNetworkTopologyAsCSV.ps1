<#
-- -----------------------------------------------------------------------------
-- =============================================================================                                
--                                 
-- FileName    : GetNetworkTopologyAsCSV.ps1
-- Description : This script gets a topology of Azure networking as CSV.
--                                                                              
-- =============================================================================                                 
--                                                                              
-- Change History                                                               
-- Name         Date           Description
-- Jeff Moss    25-OCT-2021    Created
-- -----------------------------------------------------------------------------
#>
#---------[Parameters]----------------------------------------------------------

Write-Output '"Subscription Name","VNET Name","Location","VNET Resource Group","VNET CIDR(s)","Subnet Count","Subnet Name","Subnet CIDR(s)'
$Subscriptions = Get-AzSubscription | Where-Object {($_.Name -ne "Access to Azure Active Directory") -and ($_.State -eq "Enabled")}
ForEach ($Subscription in $Subscriptions) {
  Set-AzContext $Subscription.Name | Out-null
  $VNETs = Get-AzVirtualNetwork
  ForEach ($VNET in $VNETs) {
    foreach ($subnet in $vnet.Subnets)
    {
      $csvRecord = '"' + $Subscription.Name + '","' + `
      $VNET.Name + '","' + `
      $VNET.Location + '","' + `
      $VNET.ResourceGroupName + '","' + `
      $VNET.AddressSpace.AddressPrefixes + '","' + `
      $VNET.Subnets.count + '","' + `
      $subnet.Name + '","' + `
      $subnet.AddressPrefix + '"'
      $csvRecord
    }
  }
}
   