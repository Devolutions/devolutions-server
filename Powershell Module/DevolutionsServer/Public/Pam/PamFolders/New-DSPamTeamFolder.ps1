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
        [ValidateNotNullOrEmpty()]
        [string]$name
    )
        
    BEGIN {
        Write-Verbose '[New-DSPamTeamFolder] Begin...'
    
        $URI = "$Script:DSBaseURI/api/pam/folders"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            $rootNodeResponse = Get-DSPamRootFolder
            $rootNode = $rootNodeResponse.Body.Data[0]

            if ($null -eq $rootNode) {
                throw "Abnormal condition while getting root Team folder."
            }

            $newFolderData = @{
                folderID = $rootNode.ID
                name     = $name
            }    

            $params = @{
                Uri    = $URI
                Method = 'POST'
                Body   = $newFolderData | ConvertTo-Json
            }

            $res = Invoke-DS @params
            return $res
        }
        catch {
            $exc = $_.Exception
            If ([System.Management.Automation.ActionPreference]::Break -ne $DebugPreference) {
                Write-Debug "[Exception] $exc"
            } 
        }
        
    }
    
    END {
        If ($res.isSuccess) {
            Write-Verbose '[New-DSPamTeamFolders] Completed Successfully.'
        }
        else {
            Write-Verbose "[New-DSPamTeamFolders] Error: $($res.ErrorMessage)"
        }
    }
}