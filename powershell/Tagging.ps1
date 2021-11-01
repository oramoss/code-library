Set-AzContext "<Subscription>"
$ResourceGroups = Get-AzResourceGroup
ForEach ($ResourceGroup in $ResourceGroups) {
  Set-AzResourceGroup -Name $ResourceGroup.ResourceGroupName -Tag @{"Service"="Confirm with Subscription Owner"}
}
