function Update-DSFolderCredentials {
    <#
        .SYNOPSIS
        Updates the credentials (Username/password) on a folder.
        .DESCRIPTION
        If the "ClearCredentials" switch parameter is present, it will delete both username AND password from folder. If not, it checks which
        field was provided and check with the current folder credentials to update accordingly with what credentials were supplied.
        .EXAMPLE
        > Update-DSEntry -FolderId "[guid]"" -Username "YourNewUsername" -Password "YourNewPassword"

        .EXAMPLE
        > Update-DSEntry -FolderId "[guid]" -ClearCredentials
    #>
    [CmdletBinding()]
    PARAM (
        [guid]$FolderId,
        #Folder's new username
        [string]$Username,
        #Folder's new password
        [string]$Password,
        #Used to clear credentials on a given folder
        [switch]$ClearCredentials = $false
    )
    
    BEGIN {
        Write-Verbose "[Update-DSFolderEntry] Beginning..."

        $URI = "$Script:DSBaseURI/api/connections/partial/save"

        if (!(Get-Variable DSSessionToken -Scope Global -ErrorAction SilentlyContinue) -or ([string]::IsNullOrWhiteSpace($Global:DSSessionToken))) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            if (!$ClearCredentials -and (!$Username -and !$Password)) {
                throw "No username nor password were provided. If you meant to clear the credentials, please use the ClearCredentials switch parameter."
            }

            $FolderCtx = (Get-DSFolder $ParamList.CandidEntryID -IncludeAdvancedProperties).Body.data
            $FolderCredentials = (Get-DSEntrySensitiveData $ParamList.CandidEntryID).Body.data.credentials

            $NewData = @{}

            if ($ClearCredentials) {
                #If ClearCredentials flag is present, send empty username and passwordItem
                $NewData["userName"] = ""
                $NewData["passwordItem"] = @{"hasSensitiveData" = $true ; "sensitiveData" = "" } 
            }
            else {
                #If param username was not provided (User didn't want to modify it)
                $NewData["userName"] = if ($null -eq $Username) {
                    #Check if current username is empty and set accordingly
                    if ($null -eq $FolderCredentials.userName) { "" } else { $FolderCredentials.userName }
                }
                else {
                    #Check if param username match current username and set accordingly
                    if ($Username -ne $FolderCredentials.userName) { $Username } else { $FolderCredentials.userName }
                }

                #Check if param password match current password and set accordingly
                $NewData["passwordItem"] = if ($Password -ne $FolderCredentials.password) {
                    @{"hasSensitiveData" = $true; "sensitiveData" = $Password }
                }
                else {
                    @{"hasSensitiveData" = $true; "sensitiveData" = $FolderCredentials.password }
                }
            }

            #Encrypt data for sending to backend
            $FolderCtx.data = Protect-ResourceToHexString ($NewData | ConvertTo-Json -Depth 100)
            #Empty group or else it places itself in a subfolder with same name
            $FolderCtx.group = ""

            $RequestParams = @{
                URI    = $URI
                Method = "PUT"
                Body   = $FolderCtx | ConvertTo-Json -Depth 100
            }

            $res = Invoke-DS @RequestParams
            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    
    END {
        if ($res.isSuccess) {
            Write-Verbose "[Update-DSFolder] Completed successfully!"
        }
        else {
            Write-Verbose "[Update-DSFolder] Ended with errors..."
        }
    }
}