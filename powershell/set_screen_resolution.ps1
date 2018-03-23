<#
.SYNOPSIS
PowerShell to set screen/display resolution

.DESCRIPTION

see Set-DisplayResolution, Get-DisplayResolution

.RUN
.\set_screen_resolution.ps1 -width 1024 -height 768

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

param(`
    [Parameter(Mandatory=$True)][string]$width,
    [Parameter(Mandatory=$True)][string]$height
)

try {
    Clear-Host
} catch {
    Write-Host "No text to remove from current display."
}

$scriptName = $MyInvocation.MyCommand.Name
$log = "$(get-date) - $scriptName"

Write-Host "$log Starting $scriptName"

Try {

	Write-Host "$log setting screen resolution to $width x $height"
	set-DisplayResolution -Width $width -Height $height -Force

	#Write-Host "$log Getting screen resolution"
	#wmic path Win32_VideoController get VideoModeDescription
	#wmic path Win32_VideoController get CurrentHorizontalResolution
	#wmic path Win32_VideoController get CurrentVerticalResolution
	#wmic path Win32_VideoController get CurrentNumberOfColors
	#wmic path Win32_VideoController get CurrentRefreshRate

} Catch {
    $errorMsg = $_.Exception.Message
    Throw "$log Errors found: $errorMsg"
}




schtasks.exe /U Administrator /P my_password@2016 /create /TN test /ST $time /TR "powershell.exe -file C:\users\Administrator\get-resolution.ps1"

