function New-DSPamFolder {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [string]$Name = $(throw 'You must provide a name for the new folder.'),
        [parameter(ParameterSetName = 'Default')]
        [guid]$ParentFolderId,
        [parameter(ParameterSetName = 'Root')]
        [switch]$AtRoot
    )
    
    begin {
        Write-Verbose '[New-DSPamFolder] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    process {
        # 1. Check if created inside folder and no parent were provided
        if (($PSCmdlet.ParameterSetName -eq 'Default') -and ($null -eq $ParentFolderId )) {
            throw 'You must provide the ID of the parent folder. If you want to create at root, please use "-AtRoot" flag parameter.'
        }

        # 2. Check if parent folder exists
        if ($PSCmdlet.ParameterSetName -eq 'Default') {
            $ParentFolder = ($res = (Get-DSPamFolder -FolderID $ParentFolderId)).isSuccess ? $res.Body : $(throw 'No folder were found matching the provided parent folder ID. Make sure you provide a valid parent folder ID and try again.')
        }

        # 3. Create new folder and save
        $NewFolder = @{
            folderId             = ''
            name                 = $Name
            encryptedOtpSettings = ''
        }

        if ($PSCmdlet.ParameterSetName -eq 'Root' ) {
            $RootFolder = (Get-DSPamFolder -Root).Body
            $NewFolder.folderId = $RootFolder.id
        }
        else {
            $NewFolder.folderId = $ParentFolderId
        }

        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/pam/folders"
            Method = 'POST'
            Body   = (ConvertTo-Json $NewFolder)
        }

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[New-DSPamFolder] Completed Successfully.') : (Write-Verbose '[New-DSPamFolder] Completed Successfully.')
    }
}