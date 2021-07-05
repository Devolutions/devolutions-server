function Remove-DSPamFolder {
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
        [guid]$folderID
    )
        
    BEGIN {
        Write-Verbose '[Remove-DSPamFolder] Beginning...'
    
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            $URI = "$Script:DSBaseURI/api/pam/folders/$folderID"

            $params = @{
                Uri    = $URI
                Method = 'DELETE'
            }

            Write-Verbose "[Remove-DSPamFolder] About to call with ${params.Uri}"

            $response = Invoke-DS @params

            return $response
        }
        catch {
            $exc = $_.Exception
            If ([System.Management.Automation.ActionPreference]::Break -ne $DebugPreference) {
                Write-Debug "[Exception] $exc"
            } 
        }
    }
    
    END {
        If ($? -and $response.isSuccess) {
            Write-Verbose '[Remove-DSPamFolders] Completed Successfully.'
        }
        else {
            Write-Verbose '[Remove-DSPamFolders] Ended with errors...'
        }
    }
}