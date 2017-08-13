<#
.SYNOPSIS
PowerShell script to install Chocolatey (a Windows package manager).

.DESCRIPTION
Install Chocolatey based on Chocolatey documentation.
https://chocolatey.org/install

.RUN
.\install_chocolatey.ps1

.REQUIREMENTS
Windows PowerShell >= 3

.TESTED
Windows Server 2012 R2

.AUTHOR
Ryan Williams <rwilliams5262@gmail.com>
#>

Clear-Host

$scriptName = $MyInvocation.MyCommand.Name
$log = "$(get-date) - $scriptName"

Write-Host "$log Starting $scriptName"

function installChocolatey {
    <#
    .DESCRIPTION
    Install chocolatey.
    #>
    Write-Host "$log Installing Chocolatey"
    Invoke-Expression `
     "iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex"
}

function chocolateyVersion {
    <#
    .DESCRIPTION
    Print chocolatey version.
    #>
    Write-Host "$log Chocolatey version"
    Invoke-Expression "choco.exe --version"
}

Try {
    # Install chocolatey
    installChocolatey

    # Log chocolatey version
    chocolateyVersion

} catch {
    $errorMsg = $_.Exception.Message
    Throw "$log Errors found: $errorMsg"
}