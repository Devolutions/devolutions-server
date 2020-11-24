function New-DSCredentialEntry {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
        [CmdletBinding(DefaultParameterSetName = "General")]
        param(
            [Parameter(Mandatory, ParameterSetName = "General")]
            [string]$vaultID,
            [Parameter(ParameterSetName = "General")]
            [string]$Folder,
            [Parameter(Mandatory, ParameterSetName = "General")]
            [string]$SessionName,
            [Parameter(ParameterSetName = "General")]
            [string]$Username,
            [Parameter(ParameterSetName = "General")]
            [string]$Password,
            [Parameter(ParameterSetName = "General")]
            [string]$UserDomain,
            [Parameter(Mandatory, ParameterSetName = "Passthru")]
            [string]$fullObjectAsJSon
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
            $ctx = Set-DSVaultsContext $vaultID

            $localBody = ""
            if ($PsCmdlet.ParameterSetName -eq 'General') {
                $password = EscapeForJSon $password
                $SensitiveData = @{
                    credentials = @{
                        domain = $UserDomain
                        password = $password
                        username = $username
                    }
                    userName =  $username
                    domain = $UserDomain
                    passwordItem = @{
                        hasSensitiveData = $true
                        sensitiveData = $password
                    }
                }

                $encryptedData = Protect-ResourceToHexString ($SensitiveData | ConvertTo-Json)

                $CredentialBody = @{
                    group = $folder
                    connectionType  = 26
                    data = $encryptedData
                    repositoryId = $vaultID
                    name = $SessionName
                }
               
                $localBody = $CredentialBody | ConvertTo-Json

            } else {
                $localBody = $fullObjectAsJSon
            }

            $params = @{
                Uri = $URI
                Method = 'POST'
                LegacyResponse = $true
                Body = $localBody
            }

            return Invoke-DS @params
        }

        END {
            Write-Verbose '[New-DSCredentialEntry] Exit.'
        }
    }
