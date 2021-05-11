function Update-DSEntry-old {
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [guid]$CandidEntryID = $(throw 'Entry ID is null or empty. Please provide a valid entry ID and try again.'),

        [switch]$ClearCredentials,

        #Base credential data
        [ValidateNotNullOrEmpty()]
        [string]$EntryName,
        [string]$Domain,
        [ValidateNotNullOrEmpty()]
        [string]$Username,
        [string]$Password,
        [string]$MnemonicPassword,
        [guid]$VaultID,
        [string]$Folder,
        [bool]$PromptForPassword,
    
        #More
        [string]$Description,
        [string]$Tags,
        [string]$Expiration, #ISO-8601 format (yyyy-mm-ddThh:mm:ss.000Z)

        #Events
        [bool]$CredentialViewedCommentIsRequired,
        [bool]$CredentialViewedPrompt,
        [bool]$TicketNumberIsRequiredOnCredentialViewed,

        #Security
        [Devolutions.RemoteDesktopManager.CheckOutMode]$CheckoutMode,
        [Devolutions.RemoteDesktopManager.AllowOffline]$AllowOffline,

        #PrivateKey Entry specifics...
        [ValidateSet('NoKey', 'Data')]
        [Devolutions.RemoteDesktopManager.PrivateKeyType]$PrivateKeyType,
        [string]$PrivateKeyPath,
        [string]$PrivateKeyPassphrase,
        [bool]$PromptForPassphrase,

        <# -- RDP entry specifics... -- #>

        #RDP's host name (Address)
        [string]$HostName,
        #Opens the adminstration console
        [bool]$AdminMode,
        #Port used by RDP
        [string]$Port,
        #RDP Type
        [Devolutions.RemoteDesktopManager.RDPType]$RDPType,
        #Azure Cloud Services role name
        [string]$RoleName,
        #Azure Cloud Service's instance ID
        [int]$AzureInstanceID,
        #Hyper-V Instance
        [string]$HyperVInstance,
        #Hyper-V enhanced session (Uses machine's local resources, such as USB drive or printer)
        [bool]$UseEnhancedSessionMode,
        
        <# -- General -> Local resources tab -- #>

        #RDP access to clipboard
        [bool]$UsesClipboard,
        #RDP access to "devices" (Such as cameras...)
        [bool]$UsesDevices,
        #RDP access to hard drives
        [bool]$UsesHardDrives,
        #RDP access to printers
        [bool]$UsesPrinters,
        #RDP access to serial ports
        [bool]$UsesSerialPorts,
        #RDP access to smart devices
        [bool]$UsesSmartDevices,
        #Choose destination for sounds
        [Devolutions.RemoteDesktopManager.SoundHook]$SoundHook,
        #RDP Audio quality
        [Devolutions.RemoteDesktopManager.RDPAudioQualityMode]$AudioQualityMode,
        #Record audio from RDP session
        [bool]$AudioCaptureRedirectionMode,
        #Sets the destination for Windows key combinations (ALT+TAB, for example)
        [Devolutions.RemoteDesktopManager.KeyboardHook]$KeyboardHook,

        <# -- General -> Programs tab -- #>

        #Path (including filename) of application to launch in alternate shell
        [string]$AlternateShell,
        #Path for alternate shell directory
        [string]$ShellWorkingDirectory,
        #Path (including filename and extension) of application to launch after login
        [string]$AfterLoginProgram,
        #Delay (in miliseconds) to launch application after login
        [int]$AfterLoginDelay,
        #Path (including filename and extension) of application to launch
        [string]$RemoteApplicationProgram,
        #Parameters for the remote application
        [string]$RemoteApplicationCmdLine,

        <# -- General -> Experience tab -- #>

        #Connection speed to use for RDP
        [string]$NetworkConnectionType,
        #Enable desktop background
        [bool]$DesktopBackground,
        #Enable font smoothing
        [bool]$FontSmoothing,
        #Enable desktop composition
        [bool]$DesktopComposition,
        #Enable animations
        [bool]$Animations,
        #Enable visual styles
        [bool]$VisualStyles,
        #Enable network autodetection
        [bool]$NetworkAutoDetect,
        #Enable automatic reconnection if RDP drop
        [bool]$AutoReconnection,
        #Enable DirectX redirection
        [bool]$RedirectDirectX,
        #Enable video playback redirection
        [bool]$RedirectVideoPlayback,
        #Enable content showing while dragging across screen
        [bool]$ShowContentWhileDragging,
        #Enable data compression
        [bool]$DataCompression,
        #Enable persistent bitmap caching
        [bool]$PersistentBitmapCaching,
        #Enable bandwith autodetection
        [bool]$BandwidthAutoDetect,
        [ValidateSet(
            [Devolutions.RemoteDesktopManager.DefaultBoolean]::Default,
            [Devolutions.RemoteDesktopManager.DefaultBoolean]::True,
            [Devolutions.RemoteDesktopManager.DefaultBoolean]::False
        )]
        #Sets if addons load in embedded or not
        [string]$LoadAddonsMode,
       
        <# -- User interface tab -- #>

        [ValidateSet(
            [Devolutions.RemoteDesktopManager.ConnectionDisplayMode]::External, 
            [Devolutions.RemoteDesktopManager.ConnectionDisplayMode]::Embedded, 
            [Devolutions.RemoteDesktopManager.ConnectionDisplayMode]::Undocked
        )]
        #Display mode used by RDP
        [string]$DisplayMode,
        #Display monitor used by RDP
        [Devolutions.RemoteDesktopManager.DisplayMonitor]$DisplayMonitor,
        #Virtual desktop used by RPD
        [Devolutions.RemoteDesktopManager.DisplayMonitor]$DisplayVirtualDesktop
    )
    BEGIN {
        Write-Verbose '[Update-DSEntry] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
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
                ([Devolutions.RemoteDesktopManager.ConnectionType]::RDPConfigured.value__) { Update-DSRDPEntry $Parameters; break } 
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
            Write-Verbose '[Update-DSEntry] Completed successfully!'
        }
        else {
            Write-Verbose '[Update-DSEntry] Ended with errors...'
        }
    }
}