<#
.SYNOPSIS
Powershell script part of Windows AD installation. This script manage post
AD deployment

.DESCRIPTION
Powershell script to manage post AD deployment. Create and install CA
certificate

.PARAMETER json file contain
optional

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

Clear-Host
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

Try{

	# Load variables from json file
	$json = Get-Content -Raw -Path $args | ConvertFrom-Json

	# Active Directory Certificate Services
	ADCertificate

	# Change default password policies in AD domain
	ChangeSecurityPolicies

}Catch{
	$error_msg = "$log Errors found during attempt:`n$_"
	Throw $error_msg
}
