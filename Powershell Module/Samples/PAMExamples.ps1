################################################################################
#
# This script is used to demonstrate how to use the PAM CMDlets present
# in this module. Before hand, you need to make sure you have the IDs of the
# PAM credential you want to manipulate and the user ID for approval, if
# required.
#
# The following CMDlets are used to manipulate a PAM credential:
# Get-DSPamCredential
#   Returns the PAM credential
#
# Invoke-DSPamCheckout
#   Generate a checkout request and auto-approve if possible/approverID is set
#   the same as the asking user ID.
#
# Invoke-DSPamCheckoutPending
#   If used with the -Accept flag parameter, it checks out the credential
#   and return the credential as an object and the decrypted password.
#
# Invoke-DSPamCheckin
#   Checks in a currently active credential and returns the state of said
#   credential
################################################################################

<# Setup #>
$ModulePath = Resolve-Path -Path '..\Powershell Module\Devolutions.Server'
Import-Module -Name $ModulePath -Force

[string]$Username = $env:DS_USER
[string]$Password = $env:DS_PASSWORD
[string]$DVLSUrl = $env:DS_URL

[securestring]$SecPassword = ConvertTo-SecureString $Password -AsPlainText -Force
[pscredential]$Creds = New-Object System.Management.Automation.PSCredential ($Username, $SecPassword)

$Response = New-DSSession -Credential $Creds -BaseURI $DVLSUrl 

if ($null -eq $Response.Body.data.tokenId) {
    Write-Error "Unable to authenticate to DVLS instance: $DVLSUrl"
}

<# -- Auto checkout -- #>
$Response = Invoke-DSPamCheckout -PamCredentialID '92e1d27f-6e7b-4c62-86da-a04fc22603c2'  -Verbose
$BobPassword = $Response.Body.Password
$BobCheckoutInfo = $Response.Body.CheckoutInfo

# -- Self checkout -- #
$Response = Invoke-DSPamCheckout -PamCredentialID '2735a06c-baa0-4ff9-911c-aa1fcc03ea1e' -Reason 'Because' -ApproverID '49a60972-b1ff-4be9-ac73-47c6d4a4125d'
$MauricePassword = $Response.Body.Password
$MauriceCheckoutInfo = $Response.Body.CheckoutInfo

# -- Approver checkout -- #
$Response = Invoke-DSPamCheckout -PamCredentialID '08a521fe-14f7-4ae5-b2b9-d9f6164c15e8' -ApproverID '2364ec1f-a739-450b-afe8-d85b5a3db50e' -Reason 'Because'
$CheckoutResponse = Invoke-DSPamCheckoutPending -CredentialCheckout $Response.Body -Accept -ApproverMessage 'Approved'
$KellyPassword = Get-DSPamPassword -PamCredentialID $CheckoutResponse.Body.credentialID -Decrypted
$KellyCheckoutInfo = $CheckoutResponse.Body

<# Check in #>
$BobCheckinResponse = Invoke-DSPamCheckin $BobCheckoutInfo
$MauriceCheckinResponse = Invoke-DSPamCheckin $MauriceCheckoutInfo
$KellyCheckinResponse = Invoke-DSPamCheckin $KellyCheckoutInfo