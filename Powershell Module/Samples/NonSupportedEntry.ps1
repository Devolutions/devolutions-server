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
################################################################################

# 1. Importing module
$ModulePath = (Resolve-Path (Get-Module -Name 'Devolutions.Server')).Path
Import-Module $ModulePath -Force

# 2. Authenticating
if (-Not(Test-Path env:DS_USER) -or -Not(Test-Path env:DS_PASSWORD)) { throw 'Please initialize your DS_USER and/or DS_PASSWORD in environment variables.' }
if ([string]::IsNullOrEmpty($env:DS_URL)) { throw 'Please initialize DS_URL in environement variables.' }

[pscredential]$Credentials = New-Object System.Management.Automation.PSCredential ($env:DS_USER, (ConvertTo-SecureString $env:DS_PASSWORD -AsPlainText -Force))

if (!(New-DSSession -Credential $Credentials -BaseURI $env:DS_URL).IsSuccess) {
    throw 'Could not authenticate to your Devolutions Server instance. Please validate that your credentials are valid, your URL is valid and your instance is up and running then try again.'
}

# 3. Investigate
# Automating your needs require some investigating. First of all, create a base entry with all the fields you need in Remote Desktop Manager and
# fetch it using this module.
$BaseEntryID = if (($res = Get-DSEntry -FilterBy Name -FilterValue 'AHK').isSuccess) {
    ($res.Body.data | Where-Object { $_.Name -eq 'AHK' }).ID
}
else {
    throw 'An error occured.'
}

$BaseEntryConnectionInfo = if (($res = Get-DSEntry -EntryId $BaseEntryID -AsRDMConnection).isSuccess) {
    # Cannot export classes from module. This format returns a ConnectionInfoEntity object made from the server response.
    & (Get-Module 'Devolutions.Server') { [ConnectionInfoEntity]$res.Body.data.connectionInfo }
}
else {
    throw 'Could not find an entry matching the provided ID.'
}

# It's easier to work with the data once converted to an object, and it'll also be easier to construct the XML from an object.
# Convert-XMLToPSCustomObject / Convert-XMLToPSCustomObject
$NewGUID = [guid]::NewGuid()

# Convert both Data segement and Metadata segment to PSCustomObject.
$ConnectionData = Convert-XMLToPSCustomObject ([xml]$BaseEntryConnectionInfo.Data)
$ConnectionMetaData = Convert-XMLToPSCustomObject ([xml]$BaseEntryConnectionInfo.MetaDataString)

# Edit the desired fields in both objects.
$ConnectionData.Connection.Name = 'Test'
$ConnectionData.Connection.ID = $NewGUID
$ConnectionMetaData.ConnectionMetaDataEntity.Name = 'Test'

# Convert the PSCustomObject back to a proper XML format
$ConnectionDataXML = Convert-PSCustomObjectToXML $ConnectionData.Connection 
$ConnectionMetaDataXML = Convert-PSCustomObjectToXML $ConnectionMetaData.ConnectionMetaDataEntity -RootName 'ConnectionMetaDataEntity'

# Edit the desired fields in the base object
$BaseEntryConnectionInfo.ID = $NewGUID
$BaseEntryConnectionInfo.Name = 'Test'
$BaseEntryConnectionInfo.Data = $ConnectionDataXML.OuterXML
$BaseEntryConnectionInfo.MetaDataString = $ConnectionMetaDataXML.OuterXml
$BaseEntryConnectionInfo.MetaData.Name = 'Test'

# Set the base connection data and metadata to their respective serialized XML strings
$BaseEntryConnectionInfo.Data = (Convert-XMLToSerializedString $ConnectionDataXML)
$BaseEntryConnectionInfo.MetaDataString = (Convert-XMLToSerializedString $ConnectionMetaDataXML)

$Body = ConvertTo-Json ($BaseEntryConnectionInfo) -Depth 6

$res = Invoke-WebRequest -Uri 'http://localhost/dps/api/connection/save' -Method 'PUT' -Body $Body -ContentType 'application/json' -WebSession $Global:WebSession