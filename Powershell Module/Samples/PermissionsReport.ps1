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
################################################################################
#until we publish the module in the PSGallery we load it by path...
$DSModulePath =  "..\DevolutionsServer"
$OutputPath = $PSScriptRoot

$VaultsSummaryFilename = "VaultsSummary.csv"
$RootFoldersSummaryFilename = "RootFoldersSummary.csv"
################################################################################

#----------------------------->>    Setup
if (-Not(Test-Path env:DS_USER) -or -Not(Test-Path env:DS_PASSWORD)) {
    throw "please initialize the credentials in the environment variables"  
}
if ([string]::IsNullOrEmpty($env:DS_URL)) {
    throw "Please initialize DS_URL environement variable."
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
    throw "unable to authenticate"
}

Write-Output ""
Write-Output "Generating permissions report..."

#----------------------------->>    Vaults
Write-Output "    Processing vaults"
$vaults = @()
[int]$currentPage = 1
[int]$totalPages = 1
[int]$pageSize = 100
#this loop will be moved inside the cmdlet code to reduce complexity for consumers of the module
Do {
    $res = Get-DSVaults -PageNumber $currentPage -PageSize $pageSize 
    $totalPages = $res.Body.totalPage
    $vaults += $res.Body.Data
    $currentPage++

} while ($currentPage -lt $totalPages)
#now that we have all vaults, we must get the assigned permissions by distinct Vaults
$vaultsSummary = @()
foreach ($vault in $vaults) {
    Write-Output "        Processing vault : $($vault.Name)"
    $principals = Get-DSVaultPermissions -VaultID $vault.ID -PrincipalTypes 'All' 
    $vaultsSummary += ($principals | Select-Object -Property @{Name = 'Vault'; Expression = {"$($vault.Name)"}}, Kind, Description, Name)
}
$vaultsSummary | Export-Csv -NoTypeInformation -UseCulture -Path (Join-Path -Path $OutputPath -ChildPath $VaultsSummaryFilename)

#----------------------------->>    Root level folders
$rootFoldersSummary = @()
foreach ($vault in $vaults) {
    Write-Output "        Processing root folders of vault : $($vault.Name)"
    $rootFolders = Get-DSFolders -VaultId $vault.ID 
    $rootFolders.IsSuccess | Should -Be $true

    foreach ($folder in $rootFolders.Body.Data) {
        Write-Output "            Processing folder : $($folder.Name)"
        $innerRes = Get-DSFolder -EntryId $folder.id -IncludeAdvancedProperties
        foreach ($sec in $innerRes.Body.data.security) {
            foreach ($view in $sec.ViewRoles) {
                Write-Output "            View permissions assigned to : $($view)"
            }
            foreach ($perm in $sec.Permissions) {
                Write-Output "            Security override : $($perm)"
            }
        } 
    }
    #$rootFoldersSummary += ($principals | Select-Object -Property @{Name = 'Vault'; Expression = {"$($vault.Name)"}}, Kind, Description, Name)
}
$rootFoldersSummary | Export-Csv -NoTypeInformation -UseCulture -Path (Join-Path -Path $OutputPath -ChildPath $RootFoldersSummaryFilename)



#----------------------------->>    Intermediate folders

#----------------------------->>    Entries

#----------------------------->>    Teardown
Write-Output "...Done!"
Write-Output ""
Close-DSSession | out-null
