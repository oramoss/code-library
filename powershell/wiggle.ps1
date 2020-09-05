<#
-- -----------------------------------------------------------------------------
-- =============================================================================
--                                                                              
-- FileName    : wiggle.ps1
-- Description : This script stops a screensaver kicking. Useful if that causes
--               a problem to a process you are running.
--                                                                              
-- =============================================================================
--                                                                              
-- Change History                                                               
-- Name         Date           Description
-- Jeff Moss    11-OCT-2019    Created
-- -----------------------------------------------------------------------------
#>

#Stops the screensaver kicking in by "pressing" the SCROLLLOCK key.

Clear-Host
Echo "Keep-alive with Scroll Lock..."

$WShell = New-Object -com "Wscript.Shell"

while ($true)
{
  $WShell.sendkeys("{SCROLLLOCK}")
  Start-Sleep -Milliseconds 100
  $WShell.sendkeys("{SCROLLLOCK}")
  Start-Sleep -Seconds 240
}
