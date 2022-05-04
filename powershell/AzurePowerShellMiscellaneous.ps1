# List stuff
Get-AzureVMImage| Select * | Out-Gridview –Passthru
Get-AzureVMImage | Where-Object {$_.ImageName -eq "d570a118449e48fdbe814fb54b36b60e__hwx_sandbox_hdp_2_5v6"}

#View the templates available
$Location="uksouth"
Get-AzVMImagePublisher -Location $Location #check all the publishers available
Get-AzVMImageOffer -Location $Location -PublisherName "microsoftwindowsdesktop"
Get-AzVMImageSku -Location $Location -PublisherName "microsoftwindowsdesktop" -Offer "office-365"
Get-AzVMImage -Location $Location -PublisherName "microsoftwindowsdesktop" -Offer "office-365" -Skus "win10-21h2-avd-m365-g2"

Get-AzVMImage -Location $Location -PublisherName $Publisher -Offer $offer -Skus $Skus

$PSVersionTable

# Removing stuff...
$OSDiskName = Get-AzureRmDisk -ResourceGroupName $ResourceGroupName | Select Name
echo $OSDiskName
Remove-AzureRmDisk -Force -ResourceGroupName $ResourceGroupName -DiskName $OSDiskName
Remove-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageName -Force
Remove-AzureRmNetworkInterface -Name ServerInterface01 -Force -ResourceGroupName $ResourceGroupName
Remove-AzureRmPublicIpAddress -Name $InterfaceName -Force -ResourceGroupName $ResourceGroupName
Remove-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Force

# Get Correlation from Azure Activity Log
Get-AzLog -CorrelationId <Correlation ID> -DetailedOutput

# Get RBAC for a User...
Get-AzRoleAssignment -ObjectId "ObjectID"
Get-AzRoleAssignment -SignInName "UPN"
