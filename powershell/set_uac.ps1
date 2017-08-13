<#
.SYNOPSIS
PowerShell script to set the UAC (User Access Control) value.

.DESCRIPTION
Script will set the UAC value based on a parameter input (manadatory).
UAC value 0 means disable and UAC value 1 means enable.

.PARAMETER
uacValue (int) UAC value to set.

.RUN
Enable UAC
.\set_uac.ps1 -uacValue 1

Disable UAC
.\set_uac.ps1 -uacValue 0

.REQUIREMENTS
Windows PowerShell >= 3

.TESTED
Windows 7
Windows 8.1
Windows 10
Windows Server 2008 R2
Windows Server 2012 R2
Windows Server 2016

.AUTHOR
Ryan Williams <rwilliams5262@gmail.com>
#>

param([Parameter(Mandatory=$True)][int]$uacValue)

Clear-Host

$scriptName = $MyInvocation.MyCommand.Name
$log = "$(get-date) - $scriptName"
$path = "\Software\Microsoft\Windows\CurrentVersion\policies\system"
$name = "EnableLUA"

Write-Host "$log Starting $scriptName"

function uacStatus {
    <#
    .DESCRIPTION
    Logs the UAC status to console.
    #>
    Write-Host "$log UAC status"
    REG QUERY HKLM$path /v $name
}

function setUAC($status, $value) {
    <#
    .DESCRIPTION
    Enables or disables UAC based on input.

    .PARAMETER
    status (str) UAC status
    value (int) UAC value
    #>
    Write-Host "$log $status UAC"
    New-ItemProperty `
    -Path "HKLM:$path" `
    -Name $name `
    -PropertyType DWord `
    -Value $value `
    -Force
}

Try {
    # Log UAC status
    uacStatus

    # Enable or disable UAC based on input
    if ($uacValue) {
        setUAC "Enable" $uacValue
    } else {
        setUAC "Disable" $uacValue
    }

    # LOG UAC status
    uacStatus
} Catch {
    $errorMsg = $_.Exception.Message
    Throw "$log Errors found: $errorMsg"
}