Must be running in elevated Powershell...
Must have AzFilesHybrid in system path
  https://github.com/Azure-Samples/azure-files-samples/releases
  Place in C:\app
  Unzip to C:\app\AzFilesHybrid
  cd C:\app\AzFilesHybrid
  Powershell terminal
  Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
  .\CopyToPSPath.ps1
    R

Import-Module AzFilesHybrid
	R
Connect-AzAccount
	Contributor privs required...
Select-AzSubscription ""

Join-AzStorage `
  -ResourceGroupName '?' `
  -StorageAccountName '?' `
  -DomainAccountType 'ComputerAccount' `
  -OrganizationalUnitDistinguishedName '?' `
  -EncryptionType 'RC4' `

