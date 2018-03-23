<#
.SYNOPSIS
Powershell script part of Windows AD installation. This script manage post
AD deployment

.DESCRIPTION
Powershell script to manage post AD deployment. Create and install CA
certificate set IDM for Unix and telnet service

.PARAMETER json file contain
optional

.REQUIREMENTS
Windows Porwshell 3 or greater

.TESTED
Windows 2012 R2

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

function ADCertificate{
	# Add Certificate Services

	Import-Module ServerManager
	Add-WindowsFeature Adcs-Cert-Authority

	Write-Host "Create CA and Add Certificate Authoriry role"
	Install-AdcsCertificationAuthority `
	-CAType EnterpriseRootCA `
	-CryptoProviderName "RSA#Microsoft Software Key Storage Provider" `
	-KeyLength 2048 `
	-HashAlgorithmName SHA1 `
	-ValidityPeriod Years `
	-ValidityPeriodUnits 5 `
	-CACommonName "Root CA 100" `
	-Confirm:$false `
	-Force

	#Write-Host "Add Certification Web Enrollment role"
	#Install-AdcsWebEnrollment -Confirm:$false -Force
}

function TelnetServer_Enable{
	# Enable and configure Telnet server
	Write-Host "Enabling Telnet server and set to autostart"
	Set-Service -Name TlntSvr -StartupType Automatic
	Start-Service -Name TlntSvr
	Get-Service -Name TlntSvr
}

function ChangeSecurityPolicies{
	# Modifies the default password policy for an Active Directory domain

	$Domain = Get-ADDomain
	Write-Host "Changing password security policy for AD domain $Domain"
	Set-ADDefaultDomainPasswordPolicy -Identity $Domain `
	-PasswordHistoryCount 0 `
	-MinPasswordAge 0 `
	-MaxPasswordAge 0 `
	-ComplexityEnabled $false
}

function IDManagement{
	# Enable Identity Management for UNIX (Server for NIS, password sync, Admin Tools)

	Write-Host "Enable Identity Management for UNIX"
	dism.exe /online /enable-feature /featurename:adminui /all /NoRestart
	dism.exe /online /enable-feature /featurename:nis /all /NoRestart
	dism.exe /online /enable-feature /featurename:psync /all /NoRestart
}

Try{

	# Load variables from json file
	$json = Get-Content -Raw -Path $args | ConvertFrom-Json

	# Active Directory Certificate Services
	ADCertificate

	# Identity Management for UNIX
	IDManagement

	# Enable Telnet
	TelnetServer_Enable

	# Change default password policies in AD domain
	ChangeSecurityPolicies

}Catch{
	$error_msg = "$log Errors found during attempt:`n$_"
	Throw $error_msg
}
