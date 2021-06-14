function Update-DSFolderCredentials {
    <#
        .SYNOPSIS
        Updates the credentials (Username/password) on a folder.
        .DESCRIPTION
        If the "ClearCredentials" switch parameter is present, it will delete both username AND password from folder. If not, it checks which
        field was provided and check with the current folder credentials to update accordingly with what credentials were supplied.
        .EXAMPLE
        > Update-DSEntry -CandidEntryId "[guid]"" -Username "YourNewUsername" -Password "YourNewPassword"

        .EXAMPLE
        > Update-DSEntry -CandidEntryId "[guid]" -ClearCredentials
    #>
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$ParamList
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
            if (!$ParamList.ClearCredentials -and (!($ParamList.Username) -and !($ParamList.Password))) {
                throw "No username nor password were provided. If you meant to clear the credentials, please use the ClearCredentials switch parameter."
            }

            $FolderCtx = (Get-DSFolder $ParamList.CandidEntryID -IncludeAdvancedProperties).Body.data
            $FolderCredentials = (Get-DSEntrySensitiveData $ParamList.CandidEntryID).Body.data.credentials

            $NewData = @{}

            if ($ParamList.ClearCredentials) {
                #If ClearCredentials flag is present, send empty username and passwordItem
                $NewData["userName"] = ""
                $NewData["passwordItem"] = @{"hasSensitiveData" = $true ; "sensitiveData" = "" } 
            }
            else {
                #If param username was not provided (User didn't want to modify it)
                $NewData["userName"] = if ($null -eq $ParamList.Username) {
                    #Check if current username is empty and set accordingly
                    if ($null -eq $FolderCredentials.userName) { "" } else { $FolderCredentials.userName }
                }
                else {
                    #Check if param username match current username and set accordingly
                    if ($ParamList.Username -ne $FolderCredentials.userName) { $ParamList.Username } else { $FolderCredentials.userName }
                }

                #Check if param password match current password and set accordingly
                $NewData["passwordItem"] = if ($ParamList.Password -ne $FolderCredentials.password) {
                    @{"hasSensitiveData" = $true; "sensitiveData" = $ParamList.Password }
                }
                else {
                    @{"hasSensitiveData" = $true; "sensitiveData" = $FolderCredentials.password }
                }
            }

            #Encrypt data for sending to backend
            $FolderCtx.data = Protect-ResourceToHexString ($NewData | ConvertTo-Json)
            #Empty group or else it places itself in a subfolder with same name
            $FolderCtx.group = ""

            $RequestParams = @{
                URI    = $URI
                Method = "PUT"
                Body   = $FolderCtx | ConvertTo-Json
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