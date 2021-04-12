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
        [string]$name,
        [string]$parentFolderID
    )
        
    BEGIN {
        Write-Verbose '[New-DSPamTeamFolder] Begin...'
    
        $URI = "$Script:DSBaseURI/api/pam/folders"

        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }

        if (![string]::IsNullOrEmpty($parentFolderID) -and ![guid]::TryParse($parentFolderID, $([ref][guid]::Empty))) {
            throw "Please provide a valid folder ID."
        }
    }
    
    PROCESS {
        try {
            #Creates folder in an existing folder
            if ("" -ne $parentFolderID) {
                #Check if folder exists. For testing purpose, I'm sure it exists
                $test = Get-DSPamFolder -candidFolderID $parentFolderID

                if ($test.Body -eq "[]") {
                    throw "Provided ID doesn't belong to an existing folder."
                }
                else {
                    $newFolderData = @{
                        folderID = $parentFolderID
                        name     = $name
                    }
                }
            }
            #Creates folder in root folder
            else {
                $rootNodeResponse = Get-DSPamRootFolder
                $rootNode = $rootNodeResponse.Body.Data[0]

                if ($null -eq $rootNode) {
                    throw "Abnormal condition while getting root Team folder."
                }

                $newFolderData = @{
                    folderID = $rootNode.ID
                    name     = $name
                }    
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