# Gets a list of VNETs, their Subnets and their IP Configurations (NICs)
$vnets = Get-AzVirtualNetwork
foreach ($vnet in $vnets)
  {
      "VNET: " + $vnet.Name
      "Subnet Count: " + $vnet.Subnets.count
      foreach ($subnet in $vnet.Subnets)
        {
          "..Subnet: " + $subnet.Name
          if ($Subnet.IpConfigurations.count -eq 0)
                                    {"Subnet has no IpConfigurations"}
                                  else
                                    {
            foreach ($IpConfiguration in $Subnet.IpConfigurations)
                                      {
               "...." + $IpConfiguration.Id.substring($IpConfiguration.Id.indexof("resourceGroups")+15)
                                                  }
                                                }
        }
  }
