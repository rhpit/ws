<#
.SYNOPSIS
Powershell script to get basic system information

.DESCRIPTION
This script gets basic windows system information and prints to
console output.

.REQUIREMENTS
Windows Porwshell 3 or greater

.TESTED
Windows 2012 R2

.AUTHOR
    Eduardo Cerqueira, eduardomcerqueira@gmail.com
#>

Clear-Host
Remove-Variable -Name * -Force -ErrorAction SilentlyContinue

$scriptName = $MyInvocation.MyCommand.Name
$log = "$(get-date) - $scriptName -"
Write-Host "$log Starting $scriptName"

Try{
	# Get basic windows information using Win32_OperatingSystem
	Get-CimInstance Win32_OperatingSystem | FL *

}Catch{
	$error_msg = "$log Errors found during attempt:`n$_"
	Throw $error_msg
}
