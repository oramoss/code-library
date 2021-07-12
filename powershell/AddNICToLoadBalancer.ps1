param ($VMResourceGroup,$LoadBalancerName,$NICName)

write-host "Starting..."

write-host "Parameters Supplied..."
write-host "VMResourceGroup:" $VMResourceGroup
write-host "LoadBalancerName:" $LoadBalancerName
write-host "NICName:" $NICName

write-host "Get the NIC for the supplied parameters..."
$nic = Get-AzNetworkInterface | Where-Object { ($_.ResourceGroupName -eq "$VMResourceGroup") -and ($_.Name -eq "$NICName") }
$nic

write-host "Get the Load Balancer for the supplied parameters..."
$lb = Get-AzLoadBalancer | Where-Object { ($_.ResourceGroupName -eq "$VMResourceGroup") -and ($_.Name -eq "$LoadBalancerName") }
$lb

write-host "Set the Load Balancer backend address pools configuration on the NIC variable..."
$nic.IpConfigurations[0].LoadBalancerBackendAddressPools = $lb.BackendAddressPools[0]
$nic

write-host "Apply the new NIC configuration to add the NIC to the Load Balancer back end..."
Set-AzNetworkInterface -NetworkInterface $nic

write-host "Script completed."
