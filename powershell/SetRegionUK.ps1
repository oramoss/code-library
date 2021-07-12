# Script to configure language settings for each user

#Write settings to reg key for all users who logon to machine
$RegKeyPath = "HKU:\Control Panel\International"

# Import 'International' module to Powershell session
Import-Module International

#Set Location to United Kingdom
Set-WinSystemLocale en-GB
Set-WinHomeLocation -GeoId 0xF2

# Set regional format (date/time etc.) to English (United Kingdon) - this applies to all users
Set-Culture en-GB

# Check language list for non-US input languages, exit if found
$currentlist = Get-WinUserLanguageList
$currentlist | ForEach-Object {if(($_.LanguageTag -ne "en-GB") -and ($_.LanguageTag -ne "en-US")){exit}}

# Set the language list for the user, forcing English (United Kingdom) to be the only language
Set-WinUserLanguageList en-GB -Force

exit
