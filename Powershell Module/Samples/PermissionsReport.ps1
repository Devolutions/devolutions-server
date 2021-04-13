################################################################################
#
# This script will generate a report of ASSIGNED permissions
# it must be run using an account that has full rights to every vault,
# folder, even down to entries.
#
################################################################################
if (-Not(Test-Path env:DS_USER) -or -Not(Test-Path env:DS_PASSWORD)) {
    throw "please initialize the credentials in the environment variables"  
}
if ([string]::IsNullOrEmpty($env:DS_URL)) {
    throw "Please initialize DS_URL environement variable."
}

#until we publish the module in the PSGallery we load it by path...
$modulePath = Resolve-Path -Path "..\DevolutionsServer"
Import-Module -Name $modulePath -Force
      
[string]$credUser = $env:DS_USER
[string]$credPassword = $env:DS_PASSWORD
[string]$dvlsURI = $env:DS_URL

[securestring]$secPassword = ConvertTo-SecureString $credPassword -AsPlainText -Force
[pscredential]$creds = New-Object System.Management.Automation.PSCredential ($credUser, $secPassword)

$sess = New-DSSession -Credential $creds -BaseURI $dvlsURI 

if ($null -eq $sess.Body.data.tokenId) {
    throw "unable to authenticate"
}

#----------------------------->>    Vaults
$vaults = @()
[int]$currentPage = 1
[int]$totalPages = 1
[int]$pageSize = 100
Do {
    $res = Get-DSVaults -PageNumber $currentPage -PageSize $pageSize 
    $totalPages = $res.Body.totalPage
    $vaults += $res.Body.Data
    $currentPage++

} while ($currentPage -lt $totalPages)
#now that we have all vaults, we must get the assigned permissions by distinct Vaults
$vaultsSummary = @()
foreach ($vault in $vaults) {
    Write-Output $vault.Name
    $principals = Get-DSVaultPermissions -VaultID $vault.ID -PrincipalTypes 'Applications', 'Users', 'Roles' 
    $vaultsSummary += ($principals | Select-Object -Property @{Name = 'Vault'; Expression = {"$($vault.Name)"}}, Kind, Description, Name)
    $vaultsSummary | Export-Csv -NoTypeInformation -UseCulture -Path (Join-Path -Path $PSScriptRoot -ChildPath "VaultsSummary.csv")
}
   





