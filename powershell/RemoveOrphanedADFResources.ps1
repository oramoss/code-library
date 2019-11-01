<#
-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================================================                                                                        
--                                                                                                                                                      
-- FileName    : RemoveOrphanedADFResources.ps1
-- Description : This script removes orphaned ADF resources.
--               Used in Azure DevOps Release Pipeline for ADF.
--               Adapted from script on:
--               https://docs.microsoft.com/en-us/azure/data-factory/continuous-integration-deployment
--                                                                                                                                                      
-- =============================================================================                                                                        
--                                                                                                                                                      
-- Change History                                                                                                                                      
-- Name         Date           Description
-- Jeff Moss    11-OCT-2019    Created
-- -----------------------------------------------------------------------------------------------------------------------------------------------------
#>

#----------------------------------------------------------[Parameters]----------------------------------------------------------

Param(
    [parameter(Mandatory = $true)] [String] $DataFactoryResourceGroupName,
    [parameter(Mandatory = $true)] [String] $DataFactoryName,
    [parameter(Mandatory = $true)] [String] $armTemplate
)

Write-Output "Starting RemoveOrphanedADFResources"

Write-Output "Parameters:"
Write-Output "DataFactoryResourceGroupName:$DataFactoryResourceGroupName"
Write-Output "DataFactoryName:$DataFactoryName"

$templateJson = Get-Content $armTemplate | ConvertFrom-Json
$resources = $templateJson.resources

#Triggers 
Write-Host "Getting triggers"
$triggersADF = Get-AzDataFactoryV2Trigger -DataFactoryName $DataFactoryName -ResourceGroupName $DataFactoryResourceGroupName
$triggersTemplate = $resources | Where-Object { $_.type -eq "Microsoft.DataFactory/factories/triggers" }
$triggerNames = $triggersTemplate | ForEach-Object {$_.name.Substring(37, $_.name.Length-40)}
$activeTriggerNames = $triggersTemplate | Where-Object { $_.properties.runtimeState -eq "Started" -and ($_.properties.pipelines.Count -gt 0 -or $_.properties.pipeline.pipelineReference -ne $null)} | ForEach-Object {$_.name.Substring(37, $_.name.Length-40)}
$deletedtriggers = $triggersADF | Where-Object { $triggerNames -notcontains $_.Name }

#Deleted resources
#pipelines
Write-Output "Getting pipelines"
$pipelinesADF = Get-AzDataFactoryV2Pipeline -DataFactoryName $DataFactoryName -ResourceGroupName $DataFactoryResourceGroupName
$pipelinesTemplate = $resources | Where-Object { $_.type -eq "Microsoft.DataFactory/factories/pipelines" }
$pipelinesNames = $pipelinesTemplate | ForEach-Object {$_.name.Substring(37, $_.name.Length-40)}
$deletedpipelines = $pipelinesADF | Where-Object { $pipelinesNames -notcontains $_.Name }
#datasets
Write-Output "Getting datasets"
$datasetsADF = Get-AzDataFactoryV2Dataset -DataFactoryName $DataFactoryName -ResourceGroupName $DataFactoryResourceGroupName
$datasetsTemplate = $resources | Where-Object { $_.type -eq "Microsoft.DataFactory/factories/datasets" }
$datasetsNames = $datasetsTemplate | ForEach-Object {$_.name.Substring(37, $_.name.Length-40) }
$deleteddataset = $datasetsADF | Where-Object { $datasetsNames -notcontains $_.Name }
#linkedservices
Write-Output "Getting linked services"
$linkedservicesADF = Get-AzDataFactoryV2LinkedService -DataFactoryName $DataFactoryName -ResourceGroupName $DataFactoryResourceGroupName
$linkedservicesTemplate = $resources | Where-Object { $_.type -eq "Microsoft.DataFactory/factories/linkedservices" }
$linkedservicesNames = $linkedservicesTemplate | ForEach-Object {$_.name.Substring(37, $_.name.Length-40)}
$deletedlinkedservices = $linkedservicesADF | Where-Object { $linkedservicesNames -notcontains $_.Name }

#Delete resources
Write-Output "Deleting pipelines"
$deletedpipelines | ForEach-Object { 
    Write-Output "Deleting pipeline " $_.Name
    Remove-AzDataFactoryV2Pipeline -Name $_.Name -ResourceGroupName $DataFactoryResourceGroupName -DataFactoryName $DataFactoryName -Force 
}
Write-Output "Deleting triggers"
$deletedtriggers | ForEach-Object { 
    Write-Output "Deleting trigger "  $_.Name
    $trig = Get-AzDataFactoryV2Trigger -name $_.Name -ResourceGroupName $DataFactoryResourceGroupName -DataFactoryName $DataFactoryName
    if ($trig.RuntimeState -eq "Started") {
        Stop-AzDataFactoryV2Trigger -ResourceGroupName $DataFactoryResourceGroupName -DataFactoryName $DataFactoryName -Name $_.Name -Force 
    }
    Remove-AzDataFactoryV2Trigger -Name $_.Name -ResourceGroupName $DataFactoryResourceGroupName -DataFactoryName $DataFactoryName -Force 
}
Write-Output "Deleting datasets"
$deleteddataset | ForEach-Object { 
    Write-Output "Deleting dataset " $_.Name
    Remove-AzDataFactoryV2Dataset -Name $_.Name -ResourceGroupName $DataFactoryResourceGroupName -DataFactoryName $DataFactoryName -Force 
}
Write-Output "Deleting linked services"
$deletedlinkedservices | ForEach-Object { 
    Write-Output "Deleting Linked Service " $_.Name
    Remove-AzDataFactoryV2LinkedService -Name $_.Name -ResourceGroupName $DataFactoryResourceGroupName -DataFactoryName $DataFactoryName -Force 
}

Write-Output "Ending SetADFTriggersState"
