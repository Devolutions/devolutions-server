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
        [Parameter(Mandatory)]
        [string]$folderID
    )
        
    BEGIN {
        Write-Verbose '[Remove-DSPamFolder] Begin...'
    
        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {

        if (![string]::IsNullOrWhiteSpace($folderID)) {
            $URI = "$Script:DSBaseURI/api/pam/folders/$folderID"
        } else {
            throw "Folder ID is null or not set. Please check if you have a valid folder ID."
        }

        try {
            $params = @{
                Uri    = $URI
                Method = 'DELETE'
            }

            Write-Verbose "[Remove-DSPamFolder] About to call with ${params.Uri}"

            $response = Invoke-DS @params

            if ($response.isSuccess) { 
                Write-Verbose "[Remove-DSPamFolders] Folder deletion was successful"
            }

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
        If ($?) {
            Write-Verbose '[Remove-DSPamFolders] Completed Successfully.'
        }
        else {
            Write-Verbose '[Remove-DSPamFolders] Ended with errors...'
        }
    }
}