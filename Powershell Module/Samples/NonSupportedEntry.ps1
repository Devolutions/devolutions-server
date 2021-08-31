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
Import-Module -Name (Resolve-Path -Path 'C:\dev\git\devolutions-server\Powershell Module\Devolutions.Server') -Force

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
$BaseEntry = Get-DSEntry -FilterBy Name -FilterValue 'AHK' # Fetch the entry by name
$BaseEntryID = $BaseEntry.Body.data[0].id # Get the entry's ID
$Response = Get-DSEntry -EntryId $BaseEntryID -AsRDMConnection # Get the entry as as RDM connection object

if ($Response.Body.result -eq [SaveResult]::Success) {
    # Classes are loaded in Devolutions.Server module, but you cannot export classes due to scripting language limitation. Use this format
    # to return a [ConnectionInfoEntity] type
    $BaseEntryConnectionInfo = & (Get-Module 'Devolutions.Server') { [ConnectionInfoEntity]$Response.Body.data.connectionInfo }
}
else {
    throw 'Could not find an entry matching the provided ID.'
}

# It's easier to work with the data once converted to an object, and it'll also be easier to construct the XML from an object.
# There is a CMDlet for both of these actions.
$ConnectionData = Convert-XMLToPSCustomObject ([xml]$BaseEntryConnectionInfo.Data) # Convert the connection's data segment to a PSCustomObject

$NewGUID = [guid]::NewGuid()
$ConnectionData.Connection.Name = 'Test'
$ConnectionData.Connection.ID = $NewGUID

$ConnectionDataXML = Convert-PSCustomObjectToXML $ConnectionData.Connection # Convert the PSCustomObject back to a proper XML format

$ConnectionMetaData = Convert-XMLToPSCustomObject ([xml]$BaseEntryConnectionInfo.MetaDataString) # Convert connection's metadata to PSCustomObject
$ConnectionMetaData.ConnectionMetaDataEntity.Name = 'Test'
$ConnectionMetaDataXML = Convert-PSCustomObjectToXML $ConnectionMetaData.ConnectionMetaDataEntity -RootName 'ConnectionMetaDataEntity' # Convert the PSCustomObject back to a proper XML format

$BaseEntryConnectionInfo.ID = $NewGUID
$BaseEntryConnectionInfo.Name = 'Test'
$BaseEntryConnectionInfo.Data = $ConnectionDataXML.OuterXML
$BaseEntryConnectionInfo.MetaDataString = $ConnectionMetaDataXML.OuterXml
$BaseEntryConnectionInfo.MetaData.Name = 'Test'

$Body = ConvertTo-Json ($BaseEntryConnectionInfo) -Depth 6

$res = Invoke-WebRequest -Uri 'http://localhost/dps/api/connection/save' -Method 'PUT' -Body $Body -ContentType 'application/json' -WebSession $Global:WebSession
$res
