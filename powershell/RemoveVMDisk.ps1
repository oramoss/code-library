#Define the following parameters.
$location = "uksouth"
$resourceGroup = "fg-uks-mgmt-prod-rgcom"
$originalOsDiskName = "azmgmtprodvm01_disk1_02bc916077004ad588c45a615e57dc1c"
$newOsDiskName = "azmgmtprodvm01-disk-os-01"
$virtualMachineName = "azmgmtprodvm01"

Set-AzContext "FG-Management"
#Get a list of all the managed disks in a resource group.
Get-AzDisk -ResourceGroupName $resourceGroup | Select Name
#Get the source managed disk.
$sourceDisk = Get-AzDisk -ResourceGroupName $resourceGroup -DiskName $originalOsDiskName
#Create the disk configuration.
$diskConfig = New-AzDiskConfig -SourceResourceId $sourceDisk.Id -Zone 1 -Location $sourceDisk.Location -CreateOption Copy -DiskSizeGB 127 -SkuName "Premium_LRS"
#Create the new disk.
New-AzDisk -Disk $diskConfig -DiskName $newOsDiskName -ResourceGroupName $resourceGroup
#Swap the OS Disk out for the renamed disk.
$virtualMachine = Get-AzVm -ResourceGroupName $resourceGroup -Name $virtualMachineName
$newOsDisk = Get-AzDisk -ResourceGroupName $resourceGroup -Name $newOsDiskName
Set-AzVMOSDisk -VM $virtualMachine -ManagedDiskId $newOsDisk.Id -Name $newOsDisk.Name
Update-AzVM -ResourceGroupName $resourceGroup -VM $virtualMachine
#Delete the original disk.
Remove-AzDisk -ResourceGroupName $resourceGroup -DiskName $originalOsDiskName -Force