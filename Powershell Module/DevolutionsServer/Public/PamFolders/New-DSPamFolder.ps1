function New-DSPamFolder {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
    [CmdletBinding()]
    param(
        [string]$folderID,
        [string]$name
    )
        
    BEGIN {
        Write-Verbose '[New-DSPamFolder] Begin...'
    
        $URI = "$Script:DSBaseURI/api/pam/folders"

        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            $newFolderData = @{
                folderID = $folderID
                name     = $name
            }
            
            $params = @{
                Uri    = $URI
                Method = 'POST'
                Body   = $newFolderData | ConvertTo-Json
            }

            Write-Verbose "[New-DSPamFolder] About to call with ${params.Uri}"

            $response = Invoke-DS @params

            if ($response.isSuccess) { 
                Write-Verbose "[New-DSPamFolders] Folder creation was successful"
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
            Write-Verbose '[New-DSPamFolders] Completed Successfully.'
        }
        else {
            Write-Verbose '[New-DSPamFolders] Ended with errors...'
        }
    }
}