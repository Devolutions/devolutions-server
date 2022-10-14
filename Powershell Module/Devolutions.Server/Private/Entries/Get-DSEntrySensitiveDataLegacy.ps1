function Get-DSEntrySensitiveDataLegacy {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
    [CmdletBinding()]
    [OutputType([ServerResponse])]
    param(			
        [ValidateNotNullOrEmpty()]
        [guid]$EntryId
    )
      
    BEGIN {
        Write-Verbose '[Get-DSEntrySensitiveDataLegacy] Beginning...'
    
        $URI = "$Script:DSBaseURI/api/Connections/partial/$EntryID/sensitive-data"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {   
            $params = @{
                Uri    = $URI
                Method = 'POST' #FIXME ???
            }

            Write-Verbose "[Get-DSEntrySensitiveDataLegacy] About to call $Uri"

            [ServerResponse] $response = Invoke-DS @params

            if ($response.isSuccess) { 
                Write-Verbose "[Get-DSEntrySensitiveDataLegacy] Got $($response.Body.Length)"
            }
                
            If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                Write-Debug "[Response.Body] $($response.Body)"
            }

            if ($response.Body.data.result -eq 6) {
                $response.ErrorMessage = "Resource could not be found."
                return $response
            }

            $response.Body.data = ($response.Body.Data | ConvertFrom-Json)
            
            return $response
        }
        catch {
            $exc = $_.Exception
            If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                Write-Debug "[Exception] $exc"
            } 
        }
    }
    
    END {
        If ($?) {
            Write-Verbose '[Get-DSEntrySensitiveDataLegacy] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSEntrySensitiveDataLegacy] ended with errors...'
        }
    }
}