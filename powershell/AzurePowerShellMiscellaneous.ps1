# Get version of PowerShell
$PSVersionTable

# Get versions of PS installed...
Get-InstalledModule Azure -AllVersions | Select-Object Name,Version,Path
