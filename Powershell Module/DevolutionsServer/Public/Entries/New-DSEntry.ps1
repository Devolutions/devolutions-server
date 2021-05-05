function New-DSEntry {
    <#
    .SYNOPSIS
    Creates a new entry
    .DESCRIPTION
    Creates a new entry in default vault's root if no other vault/folder are specified. For now, only entries of type "Credentials" (Default/PrivateKey) and "RDPConfigured"
    are supported, but more will join them as time goes and requests come in.
    .EXAMPLE 

    #>
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        #Connection type (Supported entries are Credentials or RDPConfigured. More to come...)
        [Devolutions.RemoteDesktopManager.ConnectionType]$ConnectionType,
        [ValidateNotNullOrEmpty()]
        #Connection sub-type. Used for connections of type Credentials. (Supported sub-type are Default or PrivateKey)
        [Devolutions.RemoteDesktopManager.CredentialResolverConnectionType]$ConnectionSubType = [Devolutions.RemoteDesktopManager.CredentialResolverConnectionType]::Default,
    
        <# -- Base entry data -- #>
        [ValidateNotNullOrEmpty()]
        #Entry's name
        [string]$EntryName,
        #Entry's domain
        [string]$Domain,
        [ValidateNotNullOrEmpty()]
        #Entry's username
        [string]$Username,
        #Entry's password
        [string]$Password,
        #Entry's mnemonic password
        [string]$MnemonicPassword,
        #Entry's vault ID
        [guid]$VaultID = [guid]::Empty,
        #Entry's location in the vault (Folder name, not ID)
        [string]$Folder,
        #Entry's prompt for password when checkout
        [bool]$PromptForPassword,
    
        <# -- More tab -- #>
        #Entry's description
        [string]$Description,
        #Entry's tags (Keywords). Each word separeted by a space is considered a keyword.
        [string]$Tags,
        #Entry's expiration date (ISO-8601 format (yyyy-mm-ddThh:mm:ss.000Z)
        [string]$Expiration,

        <# -- Events tab -- #>
        #A comment is required to view entry's credentials
        [bool]$CredentialViewedCommentIsRequired = $False,
        #A ticket number is required to view entry's credentials
        [bool]$TicketNumberIsRequiredOnCredentialViewed = $False,
        #Prompt the user for comment/ticket number
        [bool]$CredentialViewedPrompt = $False,

        <# -- Security tab -- #>
        #Entry's checkout mode
        [Devolutions.RemoteDesktopManager.CheckOutMode]$CheckoutMode = [Devolutions.RemoteDesktopManager.CheckOutMode]::Default,
        #Entry's offline mode
        [Devolutions.RemoteDesktopManager.AllowOffline]$AllowOffline = [Devolutions.RemoteDesktopManager.AllowOffline]::Default,

        <# -- PrivateKey specifics... -- #>
        [ValidateSet('NoKey', 'Data')]
        #Private key type
        [Devolutions.RemoteDesktopManager.PrivateKeyType]$PrivateKeyType = [Devolutions.RemoteDesktopManager.PrivateKeyType]::Data,
        #Full private key path (*.ppk)
        [string]$PrivateKeyPath,
        #Private key passphrase
        [string]$PrivateKeyPassphrase,
        #Prompt for passphrase before checkout
        [bool]$PromptForPassphrase,

        <# -- RDP entry specifics... -- #>
        #RDP's host name (Address)
        [string]$HostName,
        #Opens the adminstration console
        [bool]$AdminMode = $False,
        #Port used by RDP
        [string]$Port = "3389",
        #RDP Type
        [Devolutions.RemoteDesktopManager.RDPType]$RDPType = [Devolutions.RemoteDesktopManager.RDPType]::Normal,
        #Azure Cloud Services role name
        [string]$RoleName = "",
        #Azure Cloud Service's instance ID
        [int]$AzureInstanceID = 0,
        #Hyper-V Instance
        [string]$HyperVInstance = "",
        #Hyper-V enhanced session (Uses machine's local resources, such as USB drive or printer)
        [bool]$UseEnhancedSessionMode = $False,
        
        <# -- Local resources tab -- #>
        #RDP access to clipboard
        [bool]$UsesClipboard = $true,
        #RDP access to "devices" (Such as cameras...)
        [bool]$UsesDevices = $False,
        #RDP access to hard drives
        [bool]$UsesHardDrives = $true,
        #RDP access to printers
        [bool]$UsesPrinters = $False,
        #RDP access to serial ports
        [bool]$UsesSerialPorts = $true,
        #RDP access to smart devices
        [bool]$UsesSmartDevices = $False,
        #Choose destination for sounds
        [Devolutions.RemoteDesktopManager.SoundHook]$SoundHook = [Devolutions.RemoteDesktopManager.SoundHook]::BringToThisComputer,
        #RDP Audio quality
        [Devolutions.RemoteDesktopManager.RDPAudioQualityMode]$AudioQualityMode = [Devolutions.RemoteDesktopManager.RDPAudioQualityMode]::Dynamic,
        #Record audio from RDP session
        [bool]$AudioCaptureRedirectionMode = $true,

        <# -- Programs tab -- #>
        #Path (including filename) of application to launch in alternate shell
        [string]$AlternateShell,
        #Path for alternate shell directory
        [string]$ShellWorkingDirectory,

        #Path (including filename and extension) of application to launch after login
        [string]$AfterLoginProgram,
        #Delay (in miliseconds) to launch application after login
        [int]$AfterLoginDelay = 500,

        #Path (including filename and extension) of application to launch
        [string]$RemoteApplicationProgram,
        #Parameters for the remote application
        [string]$RemoteApplicationCmdLine

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
                ([Devolutions.RemoteDesktopManager.ConnectionType]::RDPConfigured) { New-DSRDPEntry -ParamList $Parameters; break }
                Default { throw "Entries of type $ConnectionType are not supported yet." }
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