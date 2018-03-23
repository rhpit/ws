<#
.SYNOPSIS
PowerShell script to get Jenkins swarm-client

.DESCRIPTION
PowerShell script for pre-configuration to make a Windows to run as Jenkins Slave
Basically:
1. Create jenkins folder to be fsroot for jslave auto start script
3. Download Jenkins Swarm client

.RUN
.\jslave_configure.ps1 \
-swarm_client_url https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/2.0/swarm-client-2.0-jar-with-dependencies.jar \
-swarm_client_path C:\Users\Administrator\Downloads\swarm-client-2.0-jar-with-dependencies.jar \
-fsroot C:\Users\Administrator\jenkins

.REQUIREMENTS
Windows PowerShell >= 3
wget

.TESTED
Windows Server 2012 R2

.AUTHOR
Eduardo Cerqueira <eduardomcerqueira@gmail.com>

#>

param(
    [Parameter(Mandatory=$True)][string]$swarm_client_url,
    [Parameter(Mandatory=$True)][string]$swarm_client_name,
    [Parameter(Mandatory=$True)][array]$fsroot_path
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

    if(Test-Path $fsroot_path){
        Write-Host "dir already exist, skipping creation: $fsroot_path"
    }else{
        mkdir $fsroot_path
        Write-Host "$log dir created: $fsroot_path"
    }

    Write-Host "Downloading $swarm_client_url"
    wget "$swarm_client_url" -OutFile "$env:USERPROFILE\Downloads\$swarm_client_name"
    Write-Host "$log file download: $env:USERPROFILE\Downloads\$swarm_client_name"

} Catch {
    $errorMsg = $_.Exception.Message
    Throw "$log Errors found: $errorMsg"
}
