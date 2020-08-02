# Get details of a tracking id:
Get-AzLog -CorrelationId <Correlation ID> -DetailedOutput
((Get-AzLog -CorrelationId <Correlation ID>).Properties.Content.statusMessage | ConvertFrom-Json -AsHashtable).error.details.message
