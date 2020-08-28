<#
-- -----------------------------------------------------------------------------
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
-- Jeff Moss    04-MAR-2020    Moved delete triggers to before delete pipelines in
--                             in case they are referenced.
-- Jeff Moss    08-MAR-2020    Added removal of Dataflows
-- Jeff Moss    27-MAY-2020    Added removal of Integration Runtimes
-- Jeff Moss    28-MAY-2020    Fixed error on Data Flows removal
-- Jeff Moss    28-MAY-2020    Commented out IR removal
-- -----------------------------------------------------------------------------
#>
#---------[Parameters]----------------------------------------------------------

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

#Get Deleted resources
#Triggers 
Write-Host "Getting triggers"
$triggersADF = Get-AzDataFactoryV2Trigger -DataFactoryName $DataFactoryName -ResourceGroupName $DataFactoryResourceGroupName
$triggersTemplate = $resources | Where-Object { $_.type -eq "Microsoft.DataFactory/factories/triggers" }
$triggerNames = $triggersTemplate | ForEach-Object {$_.name.Substring(37, $_.name.Length-40)}
$activeTriggerNames = $triggersTemplate | Where-Object { $_.properties.runtimeState -eq "Started" -and ($_.properties.pipelines.Count -gt 0 -or $_.properties.pipeline.pipelineReference -ne $null)} | ForEach-Object {$_.name.Substring(37, $_.name.Length-40)}
$deletedtriggers = $triggersADF | Where-Object { $triggerNames -notcontains $_.Name }
#pipelines
Write-Output "Getting pipelines"
$pipelinesADF = Get-AzDataFactoryV2Pipeline -DataFactoryName $DataFactoryName -ResourceGroupName $DataFactoryResourceGroupName
$pipelinesTemplate = $resources | Where-Object { $_.type -eq "Microsoft.DataFactory/factories/pipelines" }
$pipelinesNames = $pipelinesTemplate | ForEach-Object {$_.name.Substring(37, $_.name.Length-40)}
$deletedpipelines = $pipelinesADF | Where-Object { $pipelinesNames -notcontains $_.Name }
#dataflows
Write-Output "Getting dataflows"
$dataflowsADF = Get-AzDataFactoryV2Dataflow -DataFactoryName $DataFactoryName -ResourceGroupName $DataFactoryResourceGroupName
$dataflowsTemplate = $resources | Where-Object { $_.type -eq "Microsoft.DataFactory/factories/dataflows" }
$dataflowsNames = $dataflowsTemplate | ForEach-Object {$_.name.Substring(37, $_.name.Length-40)}
$deleteddataflows = $dataflowsADF | Where-Object { $dataflowsNames -notcontains $_.Name }
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
#Integrationruntimes
#Write-Host "Getting integration runtimes"
#$integrationruntimesADF = Get-AzDataFactoryV2IntegrationRuntime -DataFactoryName $DataFactoryName -ResourceGroupName $ResourceGroupName
#$integrationruntimesTemplate = $resources | Where-Object { $_.type -eq "Microsoft.DataFactory/factories/integrationruntimes" }
#$integrationruntimesNames = $integrationruntimesTemplate | ForEach-Object {$_.name.Substring(37, $_.name.Length-40)}
#$deletedintegrationruntimes = $integrationruntimesADF | Where-Object { $integrationruntimesNames -notcontains $_.Name }

#Delete the resources
Write-Output "Deleting triggers"
$deletedtriggers | ForEach-Object { 
    Write-Output "Deleting trigger "  $_.Name
    $trig = Get-AzDataFactoryV2Trigger -name $_.Name -ResourceGroupName $DataFactoryResourceGroupName -DataFactoryName $DataFactoryName
    if ($trig.RuntimeState -eq "Started") {
        Stop-AzDataFactoryV2Trigger -ResourceGroupName $DataFactoryResourceGroupName -DataFactoryName $DataFactoryName -Name $_.Name -Force 
    }
    Remove-AzDataFactoryV2Trigger -Name $_.Name -ResourceGroupName $DataFactoryResourceGroupName -DataFactoryName $DataFactoryName -Force 
}
Write-Output "Deleting pipelines"
$deletedpipelines | ForEach-Object { 
    Write-Output "Deleting pipeline " $_.Name
    Remove-AzDataFactoryV2Pipeline -Name $_.Name -ResourceGroupName $DataFactoryResourceGroupName -DataFactoryName $DataFactoryName -Force 
}
Write-Output "Deleting dataflows"
$deleteddataflows | ForEach-Object { 
    Write-Output "Deleting dataflow " $_.Name
    Remove-AzDataFactoryV2Dataflow -Name $_.Name -ResourceGroupName $DataFactoryResourceGroupName -DataFactoryName $DataFactoryName -Force 
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
#Write-Host "Deleting integration runtimes"
#$deletedintegrationruntimes | ForEach-Object { 
#    Write-Host "Deleting integration runtime " $_.Name
#    Remove-AzDataFactoryV2IntegrationRuntime -Name $_.Name -ResourceGroupName $ResourceGroupName -DataFactoryName $DataFactoryName -Force 
#}

Write-Output "Ending SetADFTriggersState"
