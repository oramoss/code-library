# List stuff
Get-AzVMImage| Select * | Out-Gridview –Passthru
Get-AzVMImage | Where-Object {$_.ImageName -eq "d570a118449e48fdbe814fb54b36b60e__hwx_sandbox_hdp_2_5v6"}

#View the templates available
$Location="UK South"
Get-AzVMImagePublisher -Location $Location #check all the publishers available
Get-AzVMImageOffer -Location $Location -PublisherName "MicrosoftWindowsServer" 
Get-AzVMImageSku -Location $Location -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer"
Get-AzVMImage -Location $Location -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2016-Datacenter"
Get-AzVMImage -Location $Location -PublisherName $Publisher -Offer $offer -Skus $Skus

# Removing stuff...
$OSDiskName = Get-AzureRmDisk -ResourceGroupName $ResourceGroupName | Select Name
echo $OSDiskName
Remove-AzDisk -Force -ResourceGroupName $ResourceGroupName -DiskName $OSDiskName
Remove-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageName -Force
Remove-AzNetworkInterface -Name ServerInterface01 -Force -ResourceGroupName $ResourceGroupName
Remove-AzPublicIpAddress -Name $InterfaceName -Force -ResourceGroupName $ResourceGroupName
Remove-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Force
