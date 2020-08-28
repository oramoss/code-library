# Get version of PowerShell
$PSVersionTable

# Get versions of PS installed...
Get-InstalledModule Azure -AllVersions | Select-Object Name,Version,Path

# Install a given version of a given module
Install-Module -Name Az.Accounts -RequiredVersion 1.9.1 -Force

# Import a given version of a given module
Import-Module -Name Az.Accounts -Version 1.9.1 -Force
