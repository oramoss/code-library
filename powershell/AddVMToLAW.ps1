Param(
[parameter(mandatory=$true)]$WorkspaceName,
[parameter(mandatory=$true)]$VMPrefix
)

Write-Output("Starting AddVMToLAW.ps1...")

# Hide breaking change warnings
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

Write-Output("Parameter Validation...")
# Parameter validation...
If (-not $WorkspaceName) {Write-Output -ForegroundColor Yellow "You must specify a Workspace in the -WorkspaceName parameter"; return}
If (-not $VMPrefix) {Write-Output -ForegroundColor Yellow "You must specify a VM prefix in the -VM parameter"; return}

Write-Output("Parameter Data Validation...")
# Parameter data validation...
$vVMs = Get-AzResource -Name $VMPrefix* -ResourceType Microsoft.Compute/virtualMachines
If (-not $vVMs) {Write-Output("No VMs of prefix " + $VMPrefix + " were found in the current subscription."); return}
$vWorkspace = Get-AzResource -Name $WorkspaceName
If (-not $WorkspaceName) {Write-Output("Workspace " + $WorkspaceName + " was not found in the current subscription."); return}

Write-Output("Get workspace details...")
# Get workspace details
$vWorkSpace = Get-AzOperationalInsightsWorkspace -Name $vWorkspace.Name -ResourceGroupName $vWorkspace.ResourceGroupName
$vWorkspaceID = $vWorkspace.CustomerID
$vworkspaceKey = (Get-AzOperationalInsightsWorkspaceSharedKeys -ResourceGroupName $vworkspace.ResourceGroupName -Name $vworkspace.Name).PrimarySharedKey

Write-Output("Link VMs to Workspace...")
# Link the VMs to the Workspace
foreach ($vVM in $vVMs) {
  Write-Output("Linking VM " + $vVM.Name + " to Workspace " + $WorkspaceName)
  try {
    Set-AzVMExtension -ResourceGroupName $vVM.ResourceGroupName -VMName $vVM.Name -Name 'MicrosoftMonitoringAgent' -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionType 'MicrosoftMonitoringAgent' -TypeHandlerVersion '1.0' -Location $vVM.Location -SettingString "{'workspaceId': '$vWorkspaceID'}" -ProtectedSettingString "{'workspaceKey': '$vworkspaceKey'}"
  }
  catch {
    Write-Output("Encountered error - moving on to next...")
  }
  finally {
    Write-Output("Cleaning up...")
  }
}

Write-Output("Finished AddVMToLAW.ps1.")
