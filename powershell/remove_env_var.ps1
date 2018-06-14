<#
.SYNOPSIS
PowerShell to remove environment variables

.DESCRIPTION
Remove environment variable in your Windows host

“User” user-level environment variable
“Machine” machine-level environment variable
“Process” process level environment variable

parameters:
vars: (array)
levels: (array) User, Machine, Process

.RUN
# remove var1 only for User level
.\remove_env_vars.ps1 -vars @('MY_VAR1') -levels @('User')

# remove var1 and var2 for all levels, do not need to specify level
.\remove_env_vars.ps1 -vars @('MY_VAR1', 'MY_VAR2')

# remove var1 and var2 only for machine level
.\remove_env_vars.ps1 -vars @('MY_VAR1', 'MY_VAR2') -levels @('Machine')

.REQUIREMENTS
Windows PowerShell >= 3

.TESTED
Windows Server 2012 R2

.AUTHOR
Paws <paws maintainers>

#>

param(`
    [Parameter(Mandatory=$True)][array]$vars,
    [Parameter(Mandatory=$False)][array]$levels
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

if (!$levels){
    $levels = ('User', 'Machine', 'Process')
}

foreach($level in $levels){
    Write-Host "$log setting environment variables for $level level"

    for ($i=1; $i -le $vars.length; $i++) {
        $varName = $vars[$i-1]
        Write-Host "$log $i. Removing variable: $varName"
        [System.Environment]::SetEnvironmentVariable("$($varName)", $null, [System.EnvironmentVariableTarget]::$level)
    }
}

Write-Host "$log Listing new environment variables"
[System.Environment]::GetEnvironmentVariables()

} Catch {
    $errorMsg = $_.Exception.Message
    Throw "$log Errors found: $errorMsg"
}
