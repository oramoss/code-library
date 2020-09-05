# Gets a list of Storage Accounts where Secure Transfer is set to Disabled
Get-AzStorageAccount | where {$_.EnableHttpsTrafficOnly -eq $False}
