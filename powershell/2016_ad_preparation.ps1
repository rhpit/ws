<#
.SYNOPSIS
Powershell script part of Windows AD installation. This script prepares
the server to run Windows Active Directory

.DESCRIPTION
Enable windows features, set computer name, add DNS to localhost

.PARAMETER json file contain
hostName new name to set on remote Windows sever

.REQUIREMENTS
Windows Porwshell 3 or greater

.TESTED
Windows Server 2016

.IMAGE
win-2016-serverstandard-x86_64-latest-pretest

.AUTHOR
    Eduardo Cerqueira, eduardomcerqueira@gmail.com
#>

Import-Module ServerManager -passthru

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

function NetworkConfig{
	# Configure Network to use static IP
	# this function cause a connection break with remote machine
	# that is driving this script or when running direcly from
	# Powershell console

	#$IP = $json.staticIP
	#$MaskBits = 24 	# This means subnet mask = 255.255.255.0
	#$Gateway = $json.gatewayIP
	$DNS = "127.0.0.1"
	$IPType = "IPv4"

	Write-Host "Setting Primary DNS IP"
	# Configure the DNS client server IP addresses
	Write-Host "Configuring DNS to $DNS"
	Set-DnsClientServerAddress -InterfaceIndex 12 -ServerAddresses $DNS
}

function Install_WinFeatures{
	Write-Host "Adding Windows Features"
	Write-Host "AD-Domain-Services"
	Install-windowsfeature -name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
}

Try{

	# Load variables from json file
	$json = Get-Content -Raw -Path $args | ConvertFrom-Json

	# Rename Computer
	RenameComputer

	# Setup Network
	NetworkConfig

	# Install Windows Features
	Install_WinFeatures

}Catch{
	$error_msg = "$log Errors found during attempt:`n$_"
	Throw $error_msg
}
