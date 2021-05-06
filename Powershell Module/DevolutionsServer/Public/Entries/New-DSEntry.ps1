function New-DSEntry {
    <#
    .SYNOPSIS
    Creates a new entry
    .DESCRIPTION
    Creates a new entry in default vault's root if no other vault/folder are specified. For now, only entries of type "Credentials" (Default/PrivateKey) and "RDPConfigured" are supported, but more will join them as time goes and requests come in.
    
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

        #Entry's name
        [ValidateNotNullOrEmpty()]
        [string]$EntryName,
        #Entry's domain
        [string]$Domain,
        [ValidateNotNullOrEmpty()]
        #Entry's username
        [string]$Username,
        #Entry's password
        [string]$Password,
        #Entry's mnemonic passwordF
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
        
        #Private key type
        [ValidateSet('NoKey', 'Data')]
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
        
        <# -- General -> Local resources tab -- #>

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
        #Sets the destination for Windows key combinations (ALT+TAB, for example)
        [ValidateSet(
            [Devolutions.RemoteDesktopManager.KeyboardHook]::OnTheLocalComputer,
            [Devolutions.RemoteDesktopManager.KeyboardHook]::InFullScreenMode,
            [Devolutions.RemoteDesktopManager.KeyboardHook]::OnTheRemoteComputer
        )]
        [string]$KeyboardHook = [Devolutions.RemoteDesktopManager.KeyboardHook]::OnTheLocalComputer,

        <# -- General -> Programs tab -- #>

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
        [string]$RemoteApplicationCmdLine,

        <# -- General -> Experience tab -- #>

        #Connection speed to use for RDP
        [string]$NetworkConnectionType = [Devolutions.RemoteDesktopManager.RDPNetworkConnectionType]::Default,
        #Enable desktop background
        [bool]$DesktopBackground = $true,
        #Enable font smoothing
        [bool]$FontSmoothing = $False,
        #Enable desktop composition
        [bool]$DesktopComposition = $False,
        #Enable animations
        [bool]$Animations = $False,
        #Enable visual styles
        [bool]$VisualStyles = $true,
        #Enable network autodetection
        [bool]$NetworkAutoDetect = $False,
        #Enable automatic reconnection if RDP drop
        [bool]$AutoReconnection = $true,
        #Enable DirectX redirection
        [bool]$RedirectDirectX = $False,
        #Enable video playback redirection
        [bool]$RedirectVideoPlayback = $False,
        #Enable content showing while dragging across screen
        [bool]$ShowContentWhileDragging = $true,
        #Enable data compression
        [bool]$DataCompression = $true,
        #Enable persistent bitmap caching
        [bool]$PersistentBitmapCaching = $true,
        #Enable bandwith autodetection
        [bool]$BandwidthAutoDetect = $true,
        [ValidateSet(
            [Devolutions.RemoteDesktopManager.DefaultBoolean]::Default,
            [Devolutions.RemoteDesktopManager.DefaultBoolean]::True,
            [Devolutions.RemoteDesktopManager.DefaultBoolean]::False
        )]
        #Sets if addons load in embedded or not
        [string]$LoadAddonsMode = [Devolutions.RemoteDesktopManager.DefaultBoolean],
       
        <# -- User interface tab -- #>

        [ValidateSet(
            [Devolutions.RemoteDesktopManager.ConnectionDisplayMode]::External, 
            [Devolutions.RemoteDesktopManager.ConnectionDisplayMode]::Embedded, 
            [Devolutions.RemoteDesktopManager.ConnectionDisplayMode]::Undocked
        )]
        #Display mode used by RDP
        [string]$DisplayMode = [Devolutions.RemoteDesktopManager.ConnectionDisplayMode]::Embedded,
        #Display monitor used by RDP
        [Devolutions.RemoteDesktopManager.DisplayMonitor]$DisplayMonitor = [Devolutions.RemoteDesktopManager.DisplayMonitor]::Primary,
        #Virtual desktop used by RPD
        [Devolutions.RemoteDesktopManager.DisplayMonitor]$DisplayVirtualDesktop = [Devolutions.RemoteDesktopManager.DisplayVirtualDesktop]::Current
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