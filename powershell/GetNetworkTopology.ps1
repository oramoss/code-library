<#
-- -----------------------------------------------------------------------------
-- =============================================================================                                
--                                 
-- FileName    : GetNetworkTopology.ps1
-- Description : This script gets a topology of Azure networking.
--                                                                              
-- =============================================================================                                 
--                                                                              
-- Change History                                                               
-- Name         Date           Description
-- Jeff Moss    25-JAN-2021    Created
-- -----------------------------------------------------------------------------
#>
#---------[Parameters]----------------------------------------------------------

$vnets = Get-AzVirtualNetwork
 foreach ($vnet in $vnets)
   {
     "VNET: " + $vnet.Name + " / Resource Group: " + $vnet.resourceGroupName + " / Location: " + $vnet.Location + " / Address Prefix: " + $vnet.AddressSpace.AddressPrefixes
     "Subnet Count: " + $vnet.Subnets.count
     foreach ($subnet in $vnet.Subnets)
       {
         "-Subnet: " + $subnet.Name + " / Address Prefix: " + $subnet.AddressPrefix
         if ($Subnet.IpConfigurations.count -eq 0)
           {"--Subnet has no IpConfigurations"}
         else
           {
           foreach ($IpConfiguration in $Subnet.IpConfigurations)
             {
               "--IP Configuration Id: " + $IpConfiguration.Id
             }
           }
       }
   }
