<#
.SYNOPSIS
PowerShell to run any command line on Windows host

.DESCRIPTION
It is a generic script to run any command line or executable on Windows host.
you need to use double quote if you want to pass arguments or have space and
the executable needs to be available at user environment

parameters:
chdir: cd into this directory before running the command

.RUN
# listing folders
.\cmd.ps1 dir
.\cmd.ps1 -chdir "C:\\Users\\Administrator" dir
# download a file
.\cmd.ps1 -chdir "C:\\Users\\Administrator\\Downloads" "wget http://apache.mesi.com.ar/tomcat/tomcat-9/v9.0.0.M21/bin/apache-tomcat-9.0.0.M21.zip"
# extract zip file
.\cmd.ps1 -chdir "C:\\Users\\Administrator\\Downloads" "7z e my-file.zip"

.REQUIREMENTS
Windows PowerShell >= 3

.TESTED
Windows Server 2012 R2

.AUTHOR
Eduardo Cerqueira <eduardomcerqueira@gmail.com>

#>

param(`
    [Parameter(Mandatory=$False)][string]$chdir,
    [Parameter(Mandatory=$True)][string]$cmd
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

	if($chdir){
        Write-Host "$log Moving chdir to $chdir"
        cd $chdir
    }

    cmd /c $cmd

	#Invoke-Expression $cmd -OutVariable output -ErrorVariable errors
	#Write-Host "---STDOUT---"
	#Write-Host $output
	#Write-Host "---STDERR---"
	#Write-Host $errors

} Catch {
    $errorMsg = $_.Exception.Message
    Throw "$log Errors found: $errorMsg"
}
