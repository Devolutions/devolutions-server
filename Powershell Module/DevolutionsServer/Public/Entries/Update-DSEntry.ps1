function Update-DSEntry {
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [guid]$CandidEntryID,

        [switch]$ClearCredentials,

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

        #PrivateKey Entry specifics...
        [ValidateSet('NoKey', 'Data')]
        [Devolutions.RemoteDesktopManager.PrivateKeyType]$PrivateKeyType = [Devolutions.RemoteDesktopManager.PrivateKeyType]::Data,
        [string]$PrivateKeyPath,
        [string]$PrivateKeyPassphrase,
        [bool]$PromptForPassphrase
    )
    BEGIN {
        Write-Verbose "[Update-DSEntry] Begining..."

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }

    PROCESS {
        try {
            $Parameters = Get-ParameterValues
            $EntryCtx = Get-DSEntry $CandidEntryID -IncludeAdvancedProperties

            if (!$EntryCtx.isSuccess) {
                throw [System.Management.Automation.ItemNotFoundException]::new("Provided entry couldn't be found. Make sure you are using a valid entry ID.")
            }

            $res = switch ($EntryCtx.Body.data.connectionType) {
                ([Devolutions.RemoteDesktopManager.ConnectionType]::Credential.value__) { Update-DSCredentialEntry $Parameters; break }
                ([Devolutions.RemoteDesktopManager.ConnectionType]::Group.value__) { Update-DSFolderCredentials $Parameters; break }
                Default { throw "Entries of type $($EntryCtx.Body.data.connectionType) are not supported yet."; break }            
            }

            Write-Verbose "[Update-DSEntry] Currently updating entry of type $($EntryCtx.Body.data.connectionType)"

            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }

    END {
        if ($? -and $res.isSuccess) {
            Write-Verbose "[Update-DSEntry] Completed successfully!"
        }
        else {
            Write-Verbose "[Update-DSEntry] Ended with errors..."
        }
    }
}