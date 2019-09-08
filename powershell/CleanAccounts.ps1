#Clean Accounts
Write-Host "Removing Azure Accounts from Azure Powershell..."
foreach ($azaccount in Get-AzureAccount)
{
    Remove-AzureAccount $azaccount.Id -Force
}
