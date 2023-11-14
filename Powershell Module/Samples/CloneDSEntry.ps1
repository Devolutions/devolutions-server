################################################################################
#
# This script will duplicate an existing entry and allow you to modify
# the values afterward.
#
# It expects the URL and the credentials to be defined in environment variables
# please refer to the SetEnvironmentVariables.ps1 script for an example of 
# setting them.
#
################################################################################

<# Setup #>
$ModulePath = Resolve-Path -Path '..\Powershell Module\Devolutions.Server'
Import-Module -Name $ModulePath -Force

[string]$Username = $env:DS_USER
[string]$Password = $env:DS_PASSWORD
[string]$DVLSUrl = $env:DS_URL

[securestring]$SecPassword = ConvertTo-SecureString $Password -AsPlainText -Force
[pscredential]$Creds = New-Object System.Management.Automation.PSCredential ($Username, $SecPassword)

$Response = New-DSSession -Credential $Creds -BaseURI $DVLSUrl -AsApplication

if ($null -eq $Response.Body.data.tokenId) {
    Write-Error "Unable to authenticate to DVLS instance: $DVLSUrl"
}

#copy the old entry and then duplicate it
$oldEntry = (Get-DSEntry -EntryId '142c0872-5ab6-440b-bc0e-d624bd84a771').Body.data
$NewEntry = $oldEntry.PSObject.Copy() #Deep copy

#Those properties need to be removed in order to create a new entry
$NewEntry.PSObject.Properties.Remove('id')
$NewEntry.PSObject.Properties.Remove('metaInformation')
$NewEntry.PSObject.Properties.Remove('resolvedInheritedPermissions')
$NewEntry.PSObject.Properties.Remove('resolvedTimeBasedUsageSettings')

#new properties, for example the name and username
$NewEntry.name = 'newEntry'
$NewEntry.userName = 'newUsername'

$NewEntryRes = New-DSEntryBase (ConvertTo-Json $NewEntry)

#----------------------------->>    Teardown
Close-DSSession | out-null
Write-Output ''
Write-Output '...Done!'
Write-Output ''
