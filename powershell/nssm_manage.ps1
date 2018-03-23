<#
.SYNOPSIS
PowerShell to invoke NSSM to manage Windows service in the Windows machine

.DESCRIPTION
you have to pass action = start, stop, restart, status and the service_name
see http://nssm.cc/commands for more details

.RUN
.\nssm_manage.ps1 -action start -service_name jslave

.REQUIREMENTS
Windows PowerShell >= 3
NSSM

.TESTED
Windows Server 2012 R2
NSSM installed by chocolatey

.AUTHOR
Eduardo Cerqueira <eduardomcerqueira@gmail.com>

#>

param(`
    [Parameter(Mandatory=$True)][string]$action,
    [Parameter(Mandatory=$True)][string]$service_name
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

	Write-Host "$log $action $service_name service"
	nssm $action $service_name

} Catch {
    $errorMsg = $_.Exception.Message
    Throw "$log Errors found: $errorMsg"
}
