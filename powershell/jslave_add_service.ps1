<#
.SYNOPSIS
PowerShell script to create a MS service to manage your Jenkins Slave

.DESCRIPTION
This script uses NSSM to install a new MS service to handle your Jenkins Slave process

.RUN
.\jslave_service.ps1 -service_name JSLAVE \
-swarm_client_path C:\Users\Administrator\Downloads\swarm-client-2.0-jar-with-dependencies.jar \
-master_url https://my-jenkins-url.com \
-fsroot C:\Users\Administrator\jenkins \
-jslave_name jslave_windows-2012R2 \
-jslave_label jslave_windows-2012R2 \
-disableSSL 1 \
-executors 1 \
-mode exclusive \
-username pit-services \
-password 123123123123123123123123123123

.RUN manually for tests and troubleshooting direct in command line
java -jar swarm-client-2.0-jar-with-dependencies.jar \
-master https://my-jenkins-url.com \
-fsroot C:\Users\Administrator\jenkins \
-name jslave_windows-2012R2 \
-labels jslave_windows-2012R2 \
-executors 1 \
-mode exclusive \
-disableSslVerification \
-username pit-services \
-password 123123123123123123123123123123

.REQUIREMENTS
Windows PowerShell >= 3
nssm installed in the Windows system
JAVA package installed
Jenkins Swarm client jar
access to path declared to fsroot

.TESTED
Windows Server 2012 R2
nssm installed from chocolatey
JAVA JRE8 installed from chocolatey
https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/2.0/swarm-client-2.0-jar-with-dependencies.jar

.AUTHOR
Eduardo Cerqueira <eduardomcerqueira@gmail.com>

#>

param(
    [Parameter(Mandatory=$True)][string]$service_name,
    [Parameter(Mandatory=$True)][string]$swarm_client_path,
    [Parameter(Mandatory=$True)][array]$master_url,
    [Parameter(Mandatory=$True)][array]$fsroot,
    [Parameter(Mandatory=$True)][array]$jslave_name,
    [Parameter(Mandatory=$True)][array]$jslave_label,
    [Parameter(Mandatory=$False)][boolean]$disableSSL,
    [Parameter(Mandatory=$True)][array]$executors,
    [Parameter(Mandatory=$True)][array]$mode,
    [Parameter(Mandatory=$False)][array]$username,
    [Parameter(Mandatory=$False)][array]$password
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

	$required_params = "-jar $swarm_client_path -master $master_url -fsroot $fsroot -name $jslave_name -labels $jslave_label -executors $executors -mode $mode"
	$optinal_params

	if ($disableSSL) {
		$optinal_params = "$optinal_params -disableSslVerification"
	}

	if ($username) {
		$optinal_params = "$optinal_params -username $username"
	}

	if ($password) {
		$optinal_params = "$optinal_params -password $password"
	}

	# create MS Service
	Write-Host "$log creating nssm service $scriptName"
	Invoke-Expression "& nssm install $service_name `"java`" `"$required_params$optinal_params`""

} Catch {
    $errorMsg = $_.Exception.Message
    Throw "$log Errors found: $errorMsg"
}
