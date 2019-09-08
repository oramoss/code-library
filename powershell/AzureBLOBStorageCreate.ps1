

Login-AzureRMAccount

# Variables    
## Global
$ResourceGroupName = "oramoss_resourcegroup"
$Location = "ukwest"

## Storage
$BLOBStorageName = "oramossblobstorage"
$BLOBStorageType = "Standard_LRS"
$BLOBContainerName = "oramossblobcontainer"

# Resource Group
Write-Host "[Start] creating $ResourceGroupName Resource Group in $Location location"
try{
    Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction Stop | Out-Null
    Write-Host "$ResourceGroupName Resource Group in $Location location already exists, skipping creation"
    }
catch{
    Write-Host "[Finish] creating $ResourceGroupName Resource Group in $Location location"
    New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location -Verbose
}


# BLOB Storage
$BLOBStorageAccount = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $BLOBStorageName -Type $BLOBStorageType -Location $Location
$BLOBStorageAccountKeys = Get-AzureRmStorageAccountKey -ResourceGroupName $ResourceGroupName -AccountName $BLOBStorageAccount.StorageAccountName
$BLOBEndPointURL = "https://" + $BLOBStorageAccount.StorageAccountName + ".blob.core.windows.net/"
$BLOBStorageContext = New-AzureStorageContext -StorageAccountName $BLOBStorageName -StorageAccountKey $BLOBStorageAccountKeys.Item(0).Value
$BLOBContainer = New-AzureStorageContainer -Name $BLOBContainerName -Permission Off -Context $BLOBStorageContext

$BLOBStorageAccountKeys
$BLOBStorageAccountKeys.Item(0)
$BLOBStorageAccountKeys.Item(1)
$BLOBEndPointURL
$BLOBStorageContext
$BLOBContainer


# Remove stuff
#Remove-AzureRmResourceGroup -Name $ResourceGroupName -Force

