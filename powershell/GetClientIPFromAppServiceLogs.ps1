# Get a file you want to analyse and place it in an accessible location and update the next line to point to it
$records = Get-Content "C:\data\JSON\PT1H.json" 

# Create a new List to enter the Client IPs into
$AllCIp = New-Object System.Collections.Generic.List[System.Object]

# Cycle round the records in the log file, each of which is a distinct JSON record
ForEach ($record in $records) {
    # Convert the record from JSON to a Hash Table
    $json=$record|ConvertFrom-Json
    # Access the Client IP and add to the list we are accumulating
    $AllCIp.Add($json.properties.CIp)
}

# Now display unique list...
$AllCIp|Sort-Object | Get-Unique
