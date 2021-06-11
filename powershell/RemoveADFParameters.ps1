<#
-- -----------------------------------------------------------------------------
-- =============================================================================                                
--                                 
-- FileName    : RemoveADFParameters.ps1
-- Description : This script removes ADF parameters from ADF ARM Template 
--               parameter file.
--               Used in Azure DevOps Release Pipeline for ADF.
--                                                                              
-- =============================================================================                                 
--                                                                              
-- Change History                                                               
-- Name         Date           Description
-- Jeff Moss    11-MAR-2020    Created
-- -----------------------------------------------------------------------------
#>
#---------[Parameters]----------------------------------------------------------

Param(
    [parameter(Mandatory = $true)] [String] $ARMTemplateParametersFile,
    [parameter(Mandatory = $true)] [String] $Wildcard
)

Write-Output "Starting RemoveADFParameters"

Write-Output "Parameters:"
Write-Output "$ARMTemplateParametersFile:$ARMTemplateParametersFile"
Write-Output "$Wildcard:$Wildcard"

$adf_convert = Get-Content -Path $ARMTemplateParametersFile -Raw | ConvertFrom-Json
$adf_convert.parameters.PSObject.Properties |
            Where-Object -FilterScript { $_.name -like $Wildcard } |
            ForEach-Object -Process {
			$adf_convert.parameters.PSObject.Properties.Remove($_.name)
            }
$adf_convert | ConvertTo-Json -Depth 100 | Out-File $ARMTemplateParametersFile -Force

Write-Output "Ending RemoveADFParameters"
