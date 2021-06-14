function New-DSFolder {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE
    #>
    [CmdletBinding()]
    PARAM (
        [string]$RepositoryId = [guid]::Empty,
        [string]$Name = $(throw 'Name was null or empty. Please try again after providing a name for your new folder.'),
        [string]$Description,
        [string]$Domain,
        [string]$Username,
        [string]$Password,
        [string[]]$Keywords,
        [string]$Group,

        [Devolutions.RemoteDesktopManager.CheckOutMode]$CheckoutMode = [Devolutions.RemoteDesktopManager.CheckOutMode]::Default,
        [Devolutions.RemoteDesktopManager.CheckOutCommentMode]$CheckoutCommentMode = [Devolutions.RemoteDesktopManager.CheckOutCommentMode]::Default
    )
    
    BEGIN {
        Write-Verbose '[New-DSEntry] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        $Body = @{
            CheckoutMode        = $CheckoutMode
            CheckOutCommentMode = $CheckoutCommentMode
            ConnectionType      = [ConnectionType]::Group
            ConnectionSubType   = 'Folder'
            Name                = $Name
            Description         = $Description
            RepositoryId        = $RepositoryId
            Group = $Group
            data                = @{
                Domain   = $Domain
                Username = $Username
            }
        }

        if ($Password) {
            $Body.data += @{
                passwordItem = @{
                    hasSensitiveData = $true
                    sensitiveData    = $Password
                }
            }
        }

        if ($Keywords) {
            $KeywordsString = ''
            foreach ($keyword in $Keywords.GetEnumerator()) {
                if ($keyword -eq $Keywords[$Keywords.Count - 1]) {
                    $KeywordsString += "$keyword"
                }
                else {
                    $KeywordsString += "$keyword "
                }
            }

            $Body += @{
                keywords = $KeywordsString
            }
        }

        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/connections/partial/save"
            Method = 'POST'
            Body   = ConvertTo-Json $Body
        }

        $res = Invoke-DS @RequestParams -Verbose
        return $res
    }
    
    END {
        if ($res.isSuccess) {
            Write-Verbose '[New-DSFolder] Completed successfully!'
        }
        else {
            Write-Verbose '[New-DSFolder] Ended with errors...'
        }
    }
}