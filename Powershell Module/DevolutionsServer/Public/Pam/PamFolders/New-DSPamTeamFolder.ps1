function New-DSPamTeamFolder {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
    [CmdletBinding()]
    param(
        [string]$ID,
        [string]$name
    )
        
    BEGIN {
        Write-Verbose '[New-DSPamTeamFolder] Begin...'
    
        $URI = "$Script:DSBaseURI/api/pam/folders"

        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            $rootNodeResponse = Get-DSPamRootFolder
            $rootNode = $rootNodeResponse.Body.Data[0]

            if ($null -eq $rootNode) {
                throw "abnormal condition while getting root Team folder"
            }

            $newFolderData = @{
                ID = $ID
                folderID = $rootNode.ID
                #TeamFolderID = $ID
                name     = $name
            }
            
            $params = @{
                Uri    = $URI
                Method = 'POST'
                Body   = $newFolderData | ConvertTo-Json
            }

            Write-Verbose "[New-DSPamTeamFolder] About to call with ${params.Uri}"

            $response = Invoke-DS @params

            if ($response.isSuccess) { 
                Write-Verbose "[New-DSPamTeamFolders] Folder creation was successful"
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
            Write-Verbose '[New-DSPamTeamFolders] Completed Successfully.'
        }
        else {
            Write-Verbose '[New-DSPamTeamFolders] Ended with errors...'
        }
    }
}