function New-DSConnectionPartial {
    <#
    .SYNOPSIS
        Creates a new entry.
    .DESCRIPTION
        Creates a new entry using a Passthru approach that performs limited validation and offers minimal services
        in this module. The goal is to provide a entry point that will not be limited by the speed with which we
        can implement new cmdlets. It the legacy module was used, or the Python SDK, an experienced user can create
        connections using almost the same payload.
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [hashtable]$Connection,
            [Parameter(Mandatory)]
            [hashtable]$CredentialSegment
        )
        
        BEGIN {
            Write-Verbose '[New-DSConnection] Beginning...'

            $URI = "$Script:DSBaseURI/api/connections/partial/save"
    
    		if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken))
			{
				throw "Session does not seem authenticated, call New-DSSession."
			}
        }
    
        PROCESS {
            #the Set-DSVaultsContext is extremely tolerant in our current DV
#            $ctx = Set-DSVaultsContext $VaultId
#            $PSBoundParameters.Remove('VaultId') | out-null

            $entryDataEncrypted = Protect-ResourceToHexString ($CredentialSegment | ConvertTo-Json)

            #must be conform with ToConnectionInfoEntity (ID and SecurityGroup omitted)
            #$Connection['data'] = $entryDataEncrypted
            $Connection['data'] = ($CredentialSegment | ConvertTo-Json)

            $params = @{
                Uri = $URI
                Method = 'POST'
                LegacyResponse = $true
                Body = $Connection | ConvertTo-Json
            }

            return Invoke-DS @params
        }

        END {
            Write-Verbose '[New-DSConnection] Exit.'
        }
    }
