ForEach ($Item in $ExpiringSoon) { 
    If ( !($ReplacementExists | 
            Where-Object { (
                    $ExpiringSoon.DisplayName -like $_.DisplayName) 
                -and ($ExpiringSoon."App Registration Name" -like $_."App Registration Name") })) 
    { $Item } 
}
   