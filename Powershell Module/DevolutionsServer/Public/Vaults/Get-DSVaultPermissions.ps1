function Get-DSVaultPermissions{
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
        [CmdletBinding()]
        param(			
            [ValidateNotNullOrEmpty()]
            [string]$VaultID,
            [ValidateSet('All', 'Applications','Users','Roles')]
            [string[]]$PrincipalTypes
        )
        
        BEGIN {
            Write-Verbose '[Get-DSVault] begin...'
    

    		if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken))
			{
				throw "Session does not seem authenticated, call New-DSSession."
			}
        }
    
        PROCESS {

            try
            {   	
                $permissions = @()
                if ('All' , 'Applications' | Where-Object { $PrincipalTypes -contains $_ }) {

                    $URI = "$Script:DSBaseURI/api/security/repositories/$($VaultID)/applications"
                    $params = @{
                        Uri = $URI
                        Method = 'GET'
                    }
                    [ServerResponse] $response = Invoke-DS @params

                    if ($response.isSuccess)
                    { 
                        $permissions += $response.body.data
                    }
        
                }
               if ('All' , 'Users' | Where-Object { $PrincipalTypes -contains $_ }) {

                    $URI = "$Script:DSBaseURI/api/security/repositories/$($VaultID)/users"
                    $params = @{
                        Uri = $URI
                        Method = 'GET'
                    }
                    [ServerResponse] $response = Invoke-DS @params

                    if ($response.isSuccess)
                    { 
                        $permissions += $response.body.data
                    }

                }
                if ('All' , 'Roles' | Where-Object { $PrincipalTypes -contains $_ }) {

                    $URI = "$Script:DSBaseURI/api/security/repositories/$($VaultID)/roles"
                    $params = @{
                        Uri = $URI
                        Method = 'GET'
                    }
                    [ServerResponse] $response = Invoke-DS @params

                    if ($response.isSuccess)
                    { 
                        $permissions += $response.body.data
                    }

                }

                return $permissions
            }
            catch
            {
                $exc = $_.Exception
                If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                        Write-Debug "[Exception] $exc"
                } 
            }
        }
    
        END {
           If ($?) {
              Write-Verbose '[Get-DSVaultPermissions] Completed Successfully.'
            } else {
                Write-Verbose '[Get-DSVaultPermissions] ended with errors...'
            }
        }
    }