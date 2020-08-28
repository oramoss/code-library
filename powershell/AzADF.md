Invoke-AzDataFactoryV2Pipeline -ResourceGroupName "<Resource Group Name>" -DataFactoryName "<Data Factory Name>" -PipelineName "<Pipeline>"
Get-AzDataFactoryV2PipelineRun -ResourceGroupName "<Resource Group Name>" -DataFactoryName "<Data Factory Name>" -PipelineRunId "<Pipeline Run ID>"

Start-AzDataFactoryV2Trigger -ResourceGroupName "<Resource Group Name>" -DataFactoryName "<Data Factory Name>" -Name "<Trigger Name>"	
