# Install relevant Az module
Install-Module -Name Az.Blueprint -Verbose ; Update-Help -Force -ErrorAction SilentlyContinue

# Get Blueprint
$blueprints = Get-AzBlueprint -SubscriptionId 'b27a00ea-04f6-4c98-9757-139aa6bf8bb0' -Name 'JeffTest' -Version 1
$blueprints

# Export Blueprint with artifacts
Export-AzBlueprintWithArtifact -Blueprint $blueprints -OutputPath blueprint.json

