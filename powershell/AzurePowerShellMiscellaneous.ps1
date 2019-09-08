# List stuff
Get-AzureVMImage| Select * | Out-Gridview –Passthru
Get-AzureVMImage | Where-Object {$_.ImageName -eq "d570a118449e48fdbe814fb54b36b60e__hwx_sandbox_hdp_2_5v6"}

#View the templates available
Get-AzureRmVMImagePublisher -Location $Location #check all the publishers available
Get-AzureRmVMImageOffer -Location $Location -PublisherName "Hortonworks" #look for offers for a publisher (Hortonworks)
Get-AzureRmVMImageSku -Location $Location -PublisherName "Hortonworks" -Offer "hortonworks-sandbox" #view SKUs for an offer (hortonworks-sandbox)
Get-AzureRmVMImage -Location $Location -PublisherName "Hortonworks" -Offer "hortonworks-sandbox" -Skus "sandbox25"
Get-AzureRmVMImage -Location $Location -PublisherName $Publisher -Offer $offer -Skus $Skus

$PSVersionTable


# Removing stuff...
$OSDiskName = Get-AzureRmDisk -ResourceGroupName $ResourceGroupName | Select Name
echo $OSDiskName
Remove-AzureRmDisk -Force -ResourceGroupName $ResourceGroupName -DiskName $OSDiskName
Remove-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageName -Force
Remove-AzureRmNetworkInterface -Name ServerInterface01 -Force -ResourceGroupName $ResourceGroupName
Remove-AzureRmPublicIpAddress -Name $InterfaceName -Force -ResourceGroupName $ResourceGroupName
Remove-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Force
