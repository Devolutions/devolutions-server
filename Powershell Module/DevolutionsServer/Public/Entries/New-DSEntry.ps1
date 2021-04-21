function New-DSEntry {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE

    .NOTES
    #>

    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [Devolutions.RemoteDesktopManager.ConnectionType]$ConnectionType,
        [ValidateNotNullOrEmpty()]
        [Devolutions.RemoteDesktopManager.CredentialResolverConnectionType]$ConnectionSubType = [Devolutions.RemoteDesktopManager.CredentialResolverConnectionType]::Default,
    
        #Base credential data
        [ValidateNotNullOrEmpty()]
        [string]$EntryName,
        [string]$Domain,
        [ValidateNotNullOrEmpty()]
        [string]$Username,
        [string]$Password,
        [string]$MnemonicPassword,
        [guid]$VaultID = [guid]::Empty,
        [string]$Folder,
        [bool]$PromptForPassword,
    
        #More
        [string]$Description,
        [string]$Tags,
        [string]$Expiration, #ISO-8601 format (yyyy-mm-ddThh:mm:ss.000Z)

        #Events
        [bool]$CredentialViewedCommentIsRequired = $False,
        [bool]$CredentialViewedPrompt = $False,
        [bool]$TicketNumberIsRequiredOnCredentialViewed = $False,

        #Security
        [Devolutions.RemoteDesktopManager.CheckOutMode]$CheckoutMode = [Devolutions.RemoteDesktopManager.CheckOutMode]::Default,
        [Devolutions.RemoteDesktopManager.AllowOffline]$AllowOffline = [Devolutions.RemoteDesktopManager.AllowOffline]::Default,

        #PrivateKey specifics...
        [ValidateSet('NoKey', 'Data')]
        [Devolutions.RemoteDesktopManager.PrivateKeyType]$PrivateKeyType = [Devolutions.RemoteDesktopManager.PrivateKeyType]::Data,
        [string]$PrivateKeyPath
    )

    BEGIN {
        Write-Verbose '[New-DSEntry] Begining...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }

    PROCESS {
        try {
            $Parameters = Get-ParameterValues
            
            $res = switch ($ConnectionType) {
                ([Devolutions.RemoteDesktopManager.ConnectionType]::Credential) { New-DSCredentialEntry -ParamList $Parameters; break }
                Default { throw "Connection of type $ConnectionType are not supported yet." }
            }

            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }

    END {
        if ($res.isSuccess) {
            Write-Verbose "[New-DSEntry] Completed successfully!"
        }
        else {
            Write-Verbose "[New-DSEntry] Ended with errors..."
        }
    } 
}