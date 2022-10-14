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

        [Parameter(ParameterSetName = 'Custom')]
        [string]$Username,
        [Parameter(ParameterSetName = 'Custom')]
        [string]$Password,
        [Parameter(ParameterSetName = 'Custom')]
        [switch]$ClearCredentials,

        [Parameter(ParameterSetName = 'Inherited')]
        [switch]$SetInherited
    )
    
    BEGIN {
        Write-Verbose '[Update-DSFolderEntry] Beginning...'

        $URI = "$Script:DSBaseURI/api/connections/partial/save"

        if (!(Get-Variable DSSessionToken -Scope Global -ErrorAction SilentlyContinue) -or ([string]::IsNullOrWhiteSpace($Global:DSSessionToken))) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        try {
            $res = switch ($PSCmdlet.ParameterSetName) {
                'Custom' { Custom $FolderId $Username $Password $ClearCredentials }
                'Inherited' { Inherited $FolderId $SetInherited }
            }

            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    
    END {
        $res.isSuccess ? (Write-Verbose '[Update-DSFolder] Completed successfully!') : (Write-Verbose '[Update-DSFolder] Ended with errors...')
    }
}

function Custom {
    param(
        [guid]$FolderId,
        [string]$Username,
        [string]$Password
    )

    process {
        if (!$ClearCredentials -and (!$Username -and !$Password)) {
            throw 'No username nor password were provided. If you meant to clear the credentials, please use the ClearCredentials switch parameter.'
        }

        $FolderCtx = ($res = Get-DSFolder $FolderId -IncludeAdvancedProperties).isSuccess ? $res.body.data : $(throw "A folder matching the GUID $($FolderId) could not be found.")

        $FolderCredentials = ($res = Get-DSEntrySensitiveData $FolderId).isSuccess ? $res.Body.data.credentials : $(throw "Sensitive data for $($FolderId) could not be fetched.")

        $NewData = @{}

        if ($ClearCredentials) {
            #If ClearCredentials flag is present, send empty username and passwordItem
            $NewData['userName'] = ''
            $NewData['passwordItem'] = @{'hasSensitiveData' = $true ; 'sensitiveData' = '' } 
        }
        else {
            #If param username was not provided (User didn't want to modify it)
            $NewData['userName'] = if ($null -eq $Username) {
                #Check if current username is empty and set accordingly
                if ($null -eq $FolderCredentials.userName) { '' } else { $FolderCredentials.userName }
            }
            else {
                #Check if param username match current username and set accordingly
                if ($Username -ne $FolderCredentials.userName) { $Username } else { $FolderCredentials.userName }
            }

            #Check if param password match current password and set accordingly
            $NewData['passwordItem'] = if ($Password -ne $FolderCredentials.password) {
                @{'hasSensitiveData' = $true; 'sensitiveData' = $Password }
            }
            else {
                @{'hasSensitiveData' = $true; 'sensitiveData' = $FolderCredentials.password }
            }
        }

        #Encrypt data for sending to backend
        $FolderCtx.data = ($NewData | ConvertTo-Json)
        #Empty group or else it places itself in a subfolder with same name
        $FolderCtx.group = $FolderCtx.group = $FolderCtx.group.Contains('\') ? ($FolderCtx.group.Substring(0, $FolderCtx.group.LastIndexOf('\'))) : ('')

        $RequestParams = @{
            URI    = $URI
            Method = 'PUT'
            Body   = $FolderCtx | ConvertTo-Json
        }

        return Invoke-DS @RequestParams
    }
}

function Inherited {
    param(
        [guid]$FolderId,
        [switch]$SetInherited
    )

    process {
        $Entry = (($res = Get-DSEntry -EntryId $FolderId).isSuccess) ? $res.body.data : $(throw "A folder matching the GUID $($FolderId) could not be found.")
            
        if ($Entry.data.credentialMode -eq 4) { Write-Error "Credential mode for folder $($FolderId) is already set to inherited."; break; }

        $Entry.data | Add-Member -NotePropertyName 'credentialConnectionId' -NotePropertyValue '1310CF82-6FAB-4B7A-9EEA-3E2E451CA2CF' -Force
        $Entry.data | Add-Member -NotePropertyName 'credentialMode' -NotePropertyValue '4' -Force

        $Entry.data = (ConvertTo-Json $Entry.Data -Depth 5)
        $Entry.group = $Entry.group.Contains('\') ? ($Entry.group.Substring(0, $Entry.group.LastIndexOf('\'))) : ('')

        return Update-DSEntryBase (ConvertTo-Json $Entry)
    }
}