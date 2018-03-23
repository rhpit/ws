<#
.SYNOPSIS
PowerShell to set environment variables

.DESCRIPTION
set environment variable in your Windows host

“User” user-level environment variable
“Machine” machine-level environment variable
“Process” process level environment variable

parameters:
vars: (hashtable)
levels: (array) User, Machine, Process

.RUN
# setting var1 and var2 only for User level
.\set_env_var.ps1 -vars @{'MY_VAR1' = 'VAR1'; 'MY_VAR2' = 'VAR2'} -levels ('User')

# setting var1 and var2 for all levels, don't need to specify
.\set_env_var.ps1 -vars @{'MY_VAR1' = 'VAR1'; 'MY_VAR2' = 'VAR2'}

# setting var1 and var2 only for Machine level
.\set_env_var.ps1 -vars @{'MY_VAR1' = 'VAR1'; 'MY_VAR2' = 'VAR2'} -levels ('Machine')


.REQUIREMENTS
Windows PowerShell >= 3

.TESTED
Windows Server 2012 R2

.AUTHOR
Eduardo Cerqueira <eduardomcerqueira@gmail.com>

#>

param(`
    [Parameter(Mandatory=$True)][hashtable]$vars,
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

    foreach ($var in $vars.GetEnumerator()) {
    	Write-Host "$($var.Name)=$($var.Value)"
    	[System.Environment]::SetEnvironmentVariable("$($var.Name)", "$($var.Value)",[System.EnvironmentVariableTarget]::$level)
	}
}

Write-Host "$log Listing new environment variables"
[System.Environment]::GetEnvironmentVariables()

} Catch {
    $errorMsg = $_.Exception.Message
    Throw "$log Errors found: $errorMsg"
}
