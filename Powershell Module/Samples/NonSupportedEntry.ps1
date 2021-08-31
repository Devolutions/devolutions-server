#######
# WIP #
#######

################################################################################
# This sample script demonstrate how it's possible to create an entry that's not 
# yet supported in Devolutions Server using Remote Desktop Manager end-points.
# This require some work on the customer side to understand what field goes where
# and how to piece the request together, but this sample should clarify things up.
#
# This sample is intended for temporary use. If you'd like a more permanent 
# solution for the entry type you're trying to create, please submit a request 
# on our forums or directly on our public GitHub repository and we'll try to code 
# the CMDlet.
#
# Please keep in mind that there's only so many hours and ressources that we can 
# allocate to develop this module, as it's only a tool for one of our product.
#
# Thank you for choosing Devolutions for your IT management needs.
################################################################################

# 1. Importing module
Import-Module -Name (Resolve-Path -Path '..\Powershell Module\Devolutions.Server') -Force

# 2. Authenticating
if (-Not(Test-Path env:DS_USER) -or -Not(Test-Path env:DS_PASSWORD)) { throw 'Please initialize your DS_USER and/or DS_PASSWORD in environment variables.' }
if ([string]::IsNullOrEmpty($env:DS_URL)) { throw 'Please initialize DS_URL in environement variables.' }

[pscredential]$Credentials = New-Object System.Management.Automation.PSCredential ($env:DS_USER, (ConvertTo-SecureString $env:DS_PASSWORD -AsPlainText -Force))

if (!(New-DSSession -Credential $Credentials -BaseURI $env:DS_URL).IsSuccess) {
    throw 'Could not authenticate to your Devolutions Server instance. Please validate that your credentials are valid, your URL is valid and your instance is up and running then try again.'
}

# 3. Investigate
# All entries vary a lot in terms of required fields, naming, etc... It is not really a feasable solution for us
# to include all entry types in this module, nor is it to give you access to a CMDlet with all possible fields (over 300).
# For this reason, you will need to investigate the entry type you want to create using this module. 
#
# To do this, we are going to create a base entry in RDM and fetch it in your script to explore the response object as a complete connection.
$BaseEntry = Get-DSEntry -FilterBy Name -FilterValue 'PSM-Server'
$BaseEntryID = $BaseEntry.Body.data[0].id
$Response = Get-DSEntry -EntryId $BaseEntryID -AsRDMConnection

($Response.Body.result -eq [SaveResult]::Success) ? ($BaseEntryConnectionInfo = $Response.Body.data.connectionInfo) : (throw 'Could not find an entry matching the provided ID.')

# Now that you have the entry, you could either update it or create a new [customobject] from scratch and save that instead. If you prefer
# updating, it is important to clear the ID and change the name, or else it won't save. The data portion of the connection is only
# available in XML, so if we need it to update the entry, we need to cast it in XML type like so:
[xml]$EntryData = $BaseEntryConnectionInfo.data
$EntryData.Connection.RemoveChild($EntryData.SelectSingleNode('//Connection/CreatedBy'))

$Node.InnerXml = Get-Date
$Body = @{
    splittedGroupMain = $BaseEntryConnectionInfo.splittedGroupMain
    connectionType    = $BaseEntryConnectionInfo.connectionType
    data              = $EntryData.InnerXml
    group             = $BaseEntryConnectionInfo.group
    groupMain         = $BaseEntryConnectionInfo.groupMain
    groups            = $BaseEntryConnectionInfo.groups
    id                = [guid]::NewGuid()
    metaData          = $BaseEntryConnectionInfo.metaData
    metaDataString    = $BaseEntryConnectionInfo.metaDataString
    name              = 'LmaoNewServer'
    repositoryID      = [guid]::Empty
} | ConvertTo-Json

$res = Invoke-WebRequest -Uri 'http://localhost/dps/api/connection/save' -Method 'PUT' -Body $Body -ContentType 'application/json' -WebSession $Global:WebSession
$res