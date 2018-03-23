<#
.SYNOPSIS
Powershell script part of Windows AD installation. This script install
Active Directory and disable firewall

.DESCRIPTION
Powershell script to Install Active Directory and disable Firewall
currently we are disabling Firewall. it could be a new rule to allow
remote connections to ports 22 and 5986 needed by Ansible and WinRM but
as part of the requirements for this script the firewall will be completed
disabled

.PARAMETER json file contain
domainName name to use for AD domain
domainShortName netbios name for AD domain
password password for Administrator account
forwardingDNS IP address to set as DNS forwarder

.REQUIREMENTS
Windows PowerShell 3 or greater

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

function ADService{
	# Active Directory Domain Services and add the first forest

	Import-Module ADDSDeployment

	Write-Host "AD Forest for domain $json.domainName"
	Install-ADDSForest `
	-CreateDnsDelegation:$false `
	-DatabasePath "C:\Windows\NTDS" `
	-DomainMode "Win2012" `
	-DomainName $json.domainName `
	-DomainNetbiosName $json.domainShortName `
	-ForestMode "Win2012" `
	-InstallDns:$true `
	-LogPath "C:\Windows\NTDS" `
	-NoRebootOnCompletion:$false `
	-SysvolPath "C:\Windows\SYSVOL" `
	-Force:$true `
	-safemodeadministratorpassword (convertto-securestring $json.password -asplaintext -force)
}

function DisableFirewall{
	# Turn off windows firewall
	Write-Host "Firewall Disabled"
	Get-NetFirewallProfile | Set-NetFirewallProfile -Enabled False
}

function SetDNSForwarder{
    if ($json.forwardingDNS){
        Set-DNSServerForwarder -IPAddress $json.forwardingDNS -PassThru
    }else{
        Write-Host "Not setting DNS forwarder, no IP address defined."
    }
}

Try{

	# Load variables from json file
	$json = Get-Content -Raw -Path $args | ConvertFrom-Json

	# Turn Firewall off
	DisableFirewall

	# give me my comments pls
	ADService

    # configure DNS forwarder, seems like ad in openstack cannot use root.hints
    SetDNSForwarder

}Catch{
	$error_msg = "$log Errors found during attempt:`n$_"
	Throw $error_msg
}
