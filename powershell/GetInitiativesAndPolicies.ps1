# Write the header
Write-Output '"Initiative ID","Initiative Name","Policy ID","Policy Name"'

# Get the Initiatives
#$records = Get-AzPolicySetDefinition | Select-Object -last 2
$records = Get-AzPolicySetDefinition

# Cycle round the initiatives
ForEach ($record in $records) {
    $Inputstring = $record.Properties.policyDefinitions.policyDefinitionId
    $CharArray = $InputString.Split(" ")
    # Loop round the Policies in the Initiative
    for ($i=0;$i -lt $CharArray.Count; $i++)
#    for ($i=0;$i -lt 2; $i++)
    {
        $policyDefinitionDisplayName = (Get-AzPolicyDefinition -ResourceId $CharArray[$i]).properties.displayName
        if ( [string]::IsNullOrEmpty( $policyDefinitionDisplayName)) {
            $PolicyName = $CharArray[$i]
        }
        else {
            $PolicyName = $policyDefinitionDisplayName
        }
        $csvRecord = '"' + $record.Name + '","' + `
                           $record.Properties.DisplayName + '","' + `
                           $CharArray[$i].Substring(53) + '","' + `
                           $PolicyName + '"'
        $csvRecord
    }
}
# Add a footer as we'll run the export interactively and it takes ages which means the session can time out
# ...the footer proves the process finished
Write-Output '"FOOTER","FOOTER","FOOTER","FOOTER"'
