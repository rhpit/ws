<#
.SYNOPSIS
Powershell script to schedule a System reboot for next 10 seconds

.DESCRIPTION
it is needed because PAWS uses Ansible to drive powershell execution and for
Ansible version 2.1.1.0 when it was tested I did not figure out how to
do a async calls through Ansible on powershell module.
If the restart is executed right away Ansible will process the call as
failed rc != 0 returning and code different than 0

.REQUIREMENTS
Windows Porwshell 3 or greater

.TESTED
Windows 2012 R2

.AUTHOR
    Eduardo Cerqueira, eduardomcerqueira@gmail.com
#>

Import-Module ServerManager -passthru

Clear-Host
Remove-Variable -Name * -Force -ErrorAction SilentlyContinue

$scriptName = $MyInvocation.MyCommand.Name
$log = "$(get-date) - $scriptName -"
Write-Host "$log Starting $scriptName"

function scheduleReboot{
	write-host "Scheduling System reboot for next 20 seconds"
	shutdown.exe /r /f /t 20
}

Try{
	# Reboot system
	scheduleReboot

}Catch{
	$error_msg = "$log Errors found during attempt:`n$_"
	Throw $error_msg
}

