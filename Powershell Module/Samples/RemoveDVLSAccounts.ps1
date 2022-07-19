################################################################################
#
# This script will delete all accounts it founds in the text file set.
# in the $usersFile variable. You can adapt the script to gather the accounts
# to be deleted from another source.
#
# It expects the URL and the credentials to be defined in environment variables
# please refer to the SetEnvironmentVariables.ps1 script for an example of 
# setting them.
# https://github.com/Devolutions/devolutions-server/blob/main/Powershell%20Module/Samples/SetEnvironmentVariables.ps1
#
# You could also customize certain variable below for managing the resulting
# data.
#
# Running this script will generate a LOT database access as well as intensive
# logging activity.  Ideally,
#       1. Do NOT run this during normal hours.
#       2. Ensure you have used our auto-archiving feature for logs.
#       3. Do a full database backup prior to run the script.
#
################################################################################
Import-Module -Name Devolutions.Server  -Force

[string]$usersFile = "c:\Temp\disabledusers.txt"
[string]$credUser = $env:DS_USER
[string]$credPassword = $env:DS_PASSWORD
[string]$dvlsURI = $env:DS_URL

[securestring]$secPassword = ConvertTo-SecureString $credPassword -AsPlainText -Force
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('UseDeclaredVarsMoreThanAssignments', '', Justification = 'False positive in Pester tests')]
[pscredential]$creds = New-Object System.Management.Automation.PSCredential ($credUser, $secPassword)

$sess = New-DSSession -Credential $creds -BaseUri $dvlsURI 
if ($null -eq $sess.Body.data.tokenId) {
    throw 'unable to authenticate'
}

# Get the content of the TXT file
$users = Get-Content $usersFile

# Get all DVLS user accounts
$allDVLSUsers = (Get-DSUsers -All).Body.Data

foreach ($user in $users)
{
    $userID = $allDVLSUsers[([array]::indexof($allDVLSUsers.Name,$user))].id
    $resp = (Remove-DSUser -CandidUserId $userID).body.data
}

Close-DSSession | out-null
Write-Output ''
Write-Output '...Done!'
Write-Output '' 