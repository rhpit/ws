<#
.SYNOPSIS
Powershell script to set password for local Administrator account

.DESCRIPTION
This script sets a password for local Administrator account through
ADSI WINNT Object

.PARAMETER json file contain
password new password for Administrator account

.REQUIREMENTS
Windows Porwshell 3 or greater

.TESTED
Windows 2012 R2

.AUTHOR
    Eduardo Cerqueira, eduardomcerqueira@gmail.com
#>

﻿Clear-Host
Remove-Variable -Name * -Force -ErrorAction SilentlyContinue

$scriptName = $MyInvocation.MyCommand.Name
$log = "$(get-date) - $scriptName -"
Write-Host "$log Starting $scriptName"

function SetAdminPassword{
	# Get local computer name
	$ComputerName = $env:COMPUTERNAME

	# Get Administrator user object
	$user = [ADSI] "WinNT://$ComputerName/Administrator,User"

	# Set new password
	$NewPassword = $json.password
	$user.SetPassword($NewPassword)

	# set password to "Never Expires"
	$ADS_UF_DONT_EXPIRE_PASSWD = 0x10000
	$user.userflags = $user.userflags[0] -bor $ADS_UF_DONT_EXPIRE_PASSWD

  	# Commit changes to local Administrator account
	$user.SetInfo()

	write-host "New password $NewPassword set successfully to Administrator account"
}

Try{

	# Load variables from json file
	$json = Get-Content -Raw -Path $args | ConvertFrom-Json

	# Set password to local Administrator account
	SetAdminPassword

}Catch{
	$error_msg = "$log Errors found during attempt:`n$_"
	Throw $error_msg
}
