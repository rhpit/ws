<#
.SYNOPSIS
PowerShell script to handle chocolatey commands.

.DESCRIPTION
This script allows users to perform the following chocolatey commands
    1. install
    2. upgrade
    3. uninstall
for an array of packages they provide.

.RUN
Install packages
.\chocolatey.ps1 -command install -packages @("python2", "git")

Upgrade packages
.\chocolatey.ps1 -command upgrade -packages @("python2")

Uninstall packages
.\chocolatey.ps1 -command uninstall -packages @("git")

.REQUIREMENTS
Windows PowerShell >= 3

.TESTED
Windows Server 2012 R2

.AUTHOR
Ryan Williams <rwilliams5262@gmail.com>
#>

param(
    [Parameter(Mandatory=$True)][string]$command,
    [Parameter(Mandatory=$True)][array]$packages
)

try {
    Clear-Host
} catch {
    Write-Host "No text to remove from current display."
}

$scriptName = $MyInvocation.MyCommand.Name
$log = "$(get-date) - $scriptName"
$choco = "C:\ProgramData\chocolatey\choco.exe"

Write-Host "$log Starting $scriptName"

function localPackageExist($package) {
    <#
    .DESCRIPTION
    Checks if the package exists locally and is exact.

    .PARAMETERS
    package (str) Package name

    .RETURN
    (bool) 1=Package exists, 0=Package does not exist
    #>
    $output = Invoke-Expression "$choco search -le $package 2>&1"

    if ("0 packages installed." -in $output) {
        # Package does not exist
        return 0
    } elseif ("1 packages installed." -in $output) {
        # Package does exist
        return 1
    }
}

function install($pkgs) {
    <#
    .DESCRIPTION
    Install the list of packages via chocolatey.

    .PARAMETERS
    pkgs (array) Packages
    #>
    Write-Host "$log Installing packages."

    For ($i=1; $i -le $pkgs.length; $i++) {
        $pkgName = $pkgs[$i-1]

        Write-Host "$log $i. Installing package: $pkgName"

        if (localPackageExist($pkgName)) {
            # Skip install package, already exists
            Write-Host "$log Package: $pkgName is already installed. Skipping"
        } else {
            # Install package
            Invoke-Expression `
             "$choco install -y --allow-empty-checksums $pkgName"
        }
    }
}

function uninstall($pkgs) {
    <#
    .DESCRIPTION
    Uninstall the list of packages via chocolatey.

    .PARAMETERS
    pkgs (array) Packages
    #>
    Write-Host "$log Uninstalling packages."

    For ($i=1; $i -le $pkgs.length; $i++) {
        $pkgName = $pkgs[$i-1]

        Write-Host "$log $i. Uninstalling package: $pkgName"

        if (localPackageExist($pkgName)) {
            # Uninstall package
            Invoke-Expression "$choco uninstall -y $pkgName"
        } else {
            # Skip uninstall package, does not exist
            Write-Host "$log Package: $pkgName is not installed. Skipping"
        }
    }
}

function upgrade($pkgs) {
    <#
    .DESCRIPTION
    Upgrade the list of packages via chocolatey.

    .PARAMETERS
    pkgs (array) Packages
    #>
    Write-Host "$log Upgrading packages."

     For ($i=1; $i -le $pkgs.length; $i++) {
        $pkgName = $pkgs[$i-1]

       Write-Host "$log $i. Upgrading package: $pkgName"

        if (localPackageExist($pkgName)) {
            # Upgrade package
            Invoke-Expression "$choco upgrade -y $pkgName"
        } else {
            # Skip upgrading package, does not exist
            Write-Host "$log Package: $pkgName is not installed. Skipping"
        }
    }
}

Try {
    if ($command -eq "install") {
        install($packages)
    } elseif ($command -eq "uninstall") {
        uninstall($packages)
    } elseif ($command -eq "upgrade") {
        upgrade($packages)
    } else {
        Write-Host "$log Command: $command is not supported!"
        Write-Host "$log Available commands: <install|uninstall|upgrade>"
    }
} Catch {
    $errorMsg = $_.Exception.Message
    Throw "$log Errors found: $errorMsg"
}