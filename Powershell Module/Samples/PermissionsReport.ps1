################################################################################
#
# This script will generate a report of ASSIGNED permissions
# it must be run using an account that has full rights to every vault,
# folder, even down to entries.
#
# It expects the URL and the credentials to be defined in environment variables
# please refer to the SetEnvironmentVariables.ps1 script for an example of 
# setting them.
#
# You could also customize certain variable below for managing the resulting
# data.
#
# Running this script will generate a LOT database access as well as intensive
# logging activity.  Ideally,
#       1. Do NOT run this during normal hours
#       2. Ensure you have used our auto-archiving feature for logs
#
################################################################################
#until we publish the module in the PSGallery we load it by path...
$DSModulePath = '..\Powershell Module\Devolutions.Server'
$OutputPath = $PSScriptRoot

$VaultsSummaryFilename = 'VaultsSummary.csv'
$EntriesSummaryFilename = 'EntriesSummary.csv'
$indentSpace = 4
################################################################################
$indentString = ''
#----------------------------->>    Helpers
function SetIndent($indent) {
    $Global:IndentString = ' '.PadLeft($indent * $Global:indentSpace)
}

function WriteIndentedOutput($str) { 
    write-output "$($Global:indentString)$($str)"
}

#----------------------------->>    Setup
if (-Not(Test-Path env:DS_USER) -or -Not(Test-Path env:DS_PASSWORD)) {
    throw 'please initialize the credentials in the environment variables'  
}
if ([string]::IsNullOrEmpty($env:DS_URL)) {
    throw 'Please initialize DS_URL environement variable.'
}

#until we publish the module in the PSGallery we load it by path...
$modulePath = Resolve-Path -Path $DSModulePath 
Import-Module -Name $modulePath -Force

[string]$credUser = $env:DS_USER
[string]$credPassword = $env:DS_PASSWORD
[string]$dvlsURI = $env:DS_URL

[securestring]$secPassword = ConvertTo-SecureString $credPassword -AsPlainText -Force
[pscredential]$creds = New-Object System.Management.Automation.PSCredential ($credUser, $secPassword)

$sess = New-DSSession -Credential $creds -BaseURI $dvlsURI 

if ($null -eq $sess.Body.data.tokenId) {
    throw 'unable to authenticate'
}
$indent = 0
Write-Output ''
Write-Output 'Generating permissions report...'

#----------------------------->>    Main
Write-Output ''
SetIndent($Indent++)
WriteIndentedOutput 'Processing vaults'

$Vaults = if (($res = Get-DSVault -All).isSuccess) { $res.Body.data } else { throw 'error getting vaults' }

#now that we have all vaults, we must get the assigned permissions by distinct Vaults
$vaultsSummary = @()
$EntriesSummary = @()

foreach ($Vault in $Vaults) {
    SetIndent($Indent++)
    WriteIndentedOutput "Processing vault : $($Vault.Name)"

    SetIndent($Indent++)
    WriteIndentedOutput '... permissions'
    $principals = Get-DSVaultPermissions -VaultID $vault.ID -PrincipalTypes 'All' 
    $vaultsSummary += ($principals | Select-Object -Property @{Name = 'Vault'; Expression = { "$($vault.Name)" } }, Kind, Description, Name)
    WriteIndentedOutput '... content'
    $EntriesSummary += Get-DSEntriesPermissions -vaultId $vault.ID -vaultName $vault.Name

    SetIndent($Indent--)

    SetIndent($Indent--)
}
Write-Output ''
SetIndent($Indent--)
$vfn = (Join-Path -Path $OutputPath -ChildPath $VaultsSummaryFilename)
WriteIndentedOutput "Saving file $($vfn)"
$vaultsSummary | Export-Csv -NoTypeInformation -UseCulture -Path $vfn
$efn = (Join-Path -Path $OutputPath -ChildPath $EntriesSummaryFilename)
WriteIndentedOutput "Saving file $($efn)"
$EntriesSummary | Sort-Object 'Vault', 'Depth', 'Name' | Export-Csv -NoTypeInformation -UseCulture -Path $efn

#----------------------------->>    Teardown
Close-DSSession | out-null
Write-Output ''
Write-Output '...Done!'
Write-Output ''
