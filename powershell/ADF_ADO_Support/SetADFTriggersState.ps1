<#
-- -----------------------------------------------------------------------------
-- =============================================================================
--                                                                              
-- FileName    : SetADFTriggersState.ps1
-- Description : This script sets the state (ON/OFF) of ADF Triggers.
--               Used in Azure DevOps Release Pipeline for ADF.
--               Only works when run on Self Hosted Agent VM as it stores
--               trigger state in a local file.
--                                                                              
-- =============================================================================
--                                                                              
-- Change History                                                               
-- Name         Date           Description
-- Jeff Moss    11-OCT-2019    Created
-- Jeff Moss    12-OCT-2019    Added display output for debug
-- Jeff Moss    25-OCT-2019    Modified to check whether trigger has any associated pipelines
--                             Only start trigger if there are any otherwise it causes error.
-- Jeff Moss    30-OCT-2019    Modified to cater for starting only those triggers which were
--                             previously started, e.g. before a release.
-- Jeff Moss    20-MAR-2020    Added code to check if the data factory exists and to skip
--                             the rest of the code if it does not. The most likely reason
--                             for the factory not existing is if this is the first time run
--                             of a Release Pipeline which is actually creating the factory.
-- -----------------------------------------------------------------------------
#>

#---------[Parameters]----------------------------------------------------------

Param(
  [Parameter(Mandatory=$true,Position=1)]
   [string]$DataFactoryName,
  [Parameter(Mandatory=$true,Position=2)]
   [string]$DataFactoryResourceGroupName,
  [Parameter(Mandatory=$true,Position=3)]
   [string]$State,
  [Parameter(Mandatory=$false,Position=4)]
   [string]$ReleaseIdentifier
)

Write-Output "Starting SetADFTriggersState"

Write-Output "Parameters:"
Write-Output " DataFactoryName:$DataFactoryName"
Write-Output " DataFactoryResourceGroupName:$DataFactoryResourceGroupName"
Write-Output " State:$State"
Write-Output " ReleaseIdentifier:$ReleaseIdentifier"

$df = Get-AzDataFactoryV2 -ResourceGroupName $DataFactoryResourceGroupName -Name $DataFactoryName -ErrorAction SilentlyContinue
Write-Output "Data Factory:"
$df

if (!$df)
{
  # The Data Factory does not exist - skip the testing - most likely first time run creating target factory
  Write-Output "Data Factory $DataFactoryName does not exist in Resource Group $DataFactoryResourceGroupName."
}
else {
  #=======================================================================================
  # Get all the ADF triggers
  #=======================================================================================
  # When running with StartPriorEnabled we are only going to start the triggers that
  # were running before this Azure DevOps release started. We get this list from a file
  # that was previously saved to the local drive on the Azure DevOps agent VM.
  # For other States we process every trigger in the repository.
  #=======================================================================================
  Write-Output "Getting list of ADF Triggers to process..."
  If ($State -eq "StartPriorEnabled") {
    if (Test-Path -Path c:\data\trigger_state_$ReleaseIdentifier.txt) {
      Write-Output "Prior Triggers Enabled File (c:\data\trigger_state_$ReleaseIdentifier.txt) exists..."
      $triggersADF = Get-Content -Path c:\data\trigger_state_$ReleaseIdentifier.txt
    }
    else {
      Write-Output "Prior Triggers Enabled File (c:\data\trigger_state_$ReleaseIdentifier.txt) does not exist..."
    }
  }
  else {
    $triggersADF = Get-AzDataFactoryV2Trigger -DataFactoryName $DataFactoryName -ResourceGroupName     $DataFactoryResourceGroupName
  }
  
  #=======================================================================================
  # Write out the list of triggers to process
  #=======================================================================================
   Write-Output "Contents of c:\data\trigger_state_$ReleaseIdentifier.txt)..."
   $triggersADF
   
  if ($State -eq "StartAll") {
    Write-Output "Starting ADF Triggers..."
    $triggersADF | ForEach-Object { 
      if ($_.Properties.Pipelines.Count -eq 0) {
        Write-Output "No Associated Pipelines for Trigger $_.Name - start not attempted"
      } 
      else {
        Write-Output "Starting Trigger " $_.Name
        Start-AzDataFactoryV2Trigger -ResourceGroupName $DataFactoryResourceGroupName -DataFactoryName $DataFactoryName  - Name $_.name -Force 
        Start-Sleep -s 10
      }
    }
  }
  elseif ($State -eq "StartPriorEnabled") {
    Write-Output "Starting ADF Triggers which were previously enabled (at the start of a release, for example)..."
  
      if ($triggersADF -eq $null) {
        Write-Output "No triggers to restart"
      }
      else {
        $triggersADF | ForEach { 
        Write-Output "Starting Trigger  $_"
        Start-AzDataFactoryV2Trigger -ResourceGroupName $DataFactoryResourceGroupName -DataFactoryName $DataFactoryName  - Name $_ -Force 
        Start-Sleep -s 10
      }
    }
  } 
  elseif ($State -eq "Stop") {
    Write-Output "Stopping ADF Triggers..."
    $triggersADF | ForEach-Object { 
      if($_.RuntimeState -eq "Started") {
        Write-Output "Stopping Trigger " $_.Name
        Stop-AzDataFactoryV2Trigger -ResourceGroupName $DataFactoryResourceGroupName -DataFactoryName $DataFactoryName -  Name $_.name -Force 
        Add-Content -Path c:\data\trigger_state_$ReleaseIdentifier.txt -Value $_.Name
      }
      else {
        Write-Output "Trigger already in stopped state" $_.Name
      }
    }
  } 
  else {
    Write-Output "Invalid Action: $State"
  }
}

Write-Output "Ending SetADFTriggersState"
