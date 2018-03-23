<#
.SYNOPSIS
PowerShell to get screen/display resolution

.DESCRIPTION
see Set-DisplayResolution, Get-DisplayResolution

.RUN
.\get_screen_resolution.ps1

.REQUIREMENTS
Windows PowerShell >= 3

.TESTED
Windows Server 2012 R2
Windows Server 2016
Windows 7
Windows 10

.AUTHOR
Eduardo Cerqueira <eduardomcerqueira@gmail.com>

#>

try {
    Clear-Host
} catch {
    Write-Host "No text to remove from current display."
}

$scriptName = $MyInvocation.MyCommand.Name
$log = "$(get-date) - $scriptName"

Write-Host "$log Starting $scriptName"

Try {

	Write-Host "$log Getting current screen resolution"
	Get-DisplayResolution

	Write-Host "$log win32_videocontroller info"
	Get-WmiObject win32_videocontroller

} Catch {
    $errorMsg = $_.Exception.Message
    Throw "$log Errors found: $errorMsg"
}
