<#
.SYNOPSIS
Powershell script to rename local computer

.DESCRIPTION
This script is used to set a name or rename a local computer. the new name
is passed by parameter and wil be set if the name is differrent than the
current in use.

.PARAMETER json file contain
hostName new name to set on remote Windows sever

.REQUIREMENTS
Windows Porwshell 3 or greater

.TESTED
Windows 2012 R2

.AUTHOR
    Eduardo Cerqueira, eduardomcerqueira@gmail.com
#>

try {
    Clear-Host
} catch {
    Write-Host "No text to remove from current display."
}

Remove-Variable -Name * -Force -ErrorAction SilentlyContinue

$scriptName = $MyInvocation.MyCommand.Name
$log = "$(get-date) - $scriptName -"
Write-Host "$log Starting $scriptName"

function RenameComputer{
	if ($json.hostName){
		$ComputerName = $json.hostName
	}else{
		$ComputerName = "WINSRV01"
	}

	if($ComputerName -ne $env:COMPUTERNAME){
		write-host "Renaming computer to $ComputerName"
		Rename-Computer -NewName $ComputerName
	}else{
		write-host "hostname already set to $ComputerName"
	}
}

Try{
	# Load variables from json file
	$json = Get-Content -Raw -Path $args | ConvertFrom-Json

	# Rename Computer
	RenameComputer

}Catch{
	$error_msg = "$log Errors found during attempt:`n$_"
	Throw $error_msg
}
