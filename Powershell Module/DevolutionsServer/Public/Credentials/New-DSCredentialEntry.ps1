function New-DSCredentialEntry {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]$VaultId,
            [string]$Folder,
            [Parameter(Mandatory)]
            [string]$EntryName,
            [string]$Username,
            [string]$Password,
            [string]$UserDomain
        )
        
        BEGIN {
            Write-Verbose '[New-DSCredentialEntry] begin...'

            $URI = "$Script:DSBaseURI/api/connections/partial/save"
    
    		if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken))
			{
				throw "Session does not seem authenticated, call New-DSSession."
			}
        }
    
        PROCESS {
            #the Set-DSVaultsContext is extremely tolerant in our current DVLS iteration
            $ctx = Set-DSVaultsContext $VaultId
            $PSBoundParameters.Remove('VaultId') | out-null

            $credSegment = New-DSCredentialSegment -Username $username -Password $password -UserDomain $UserDomain 
            $EntryData = $credSegment + @{
                group = $Folder
                connectionType  = 26
                repositoryID = $VaultId
                name = $EntryName
            }

            $encryptedData = Protect-ResourceToHexString ($EntryData | ConvertTo-Json)

            $CredentialBody = @{
                group = $folder
                connectionType  = 26
                data = $encryptedData
                repositoryId = $VaultId
                name = $EntryName
            }
            
            $params = @{
                Uri = $URI
                Method = 'POST'
                LegacyResponse = $true
                Body = $CredentialBody | ConvertTo-Json
            }

            return Invoke-DS @params
        }

        END {
            Write-Verbose '[New-DSCredentialEntry] Exit.'
        }
    }
