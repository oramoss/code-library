$resourceGroups = Get-AzureRmResourceGroup
foreach ($resourceGroup in $resourceGroups){
    $lock = Get-AzureRmResourceLock -ResourceGroupName $resourceGroup.ResourceGroupName
    if ($null -eq $lock){
        Write-Host "$($resourceGroup.ResourceGroupName) is missing a lock"
    }
}
