function New-DSRDPEntry {
    <#
    .SYNOPSIS
    Creates a new RDP entry
    .DESCRIPTION
    Creates a new RDP entry with the parameters supplied. All fields have a default value corresponding to those of Remote Desktop Manager.
    .EXAMPLE

    #>
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [Devolutions.RemoteDesktopManager.ConnectionType]$ConnectionType,
        [ValidateNotNullOrEmpty()]
        <# -- Base entry data -- #>

        #Entry's name
        [ValidateNotNullOrEmpty()]
        [string]$Name,
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
        [string]$Group,
        #Entry's prompt for password when checkout
        [bool]$PromptCredentials,
    
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

        <# -- RDP entry specifics... -- #>

        #RDP's host name (Address)
        [string]$HostName,
        #Opens the adminstration console
        [bool]$AdminMode = $False,
        #Port used by RDP
        [string]$Port = '3389',
        #RDP Type
        [Devolutions.RemoteDesktopManager.RDPType]$RDPType = [Devolutions.RemoteDesktopManager.RDPType]::Normal,
        #Azure Cloud Services role name
        [string]$RoleName = '',
        #Azure Cloud Service's instance ID
        [int]$AzureInstanceID = 0,
        #Hyper-V Instance
        [string]$HyperVInstance = '',
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
        [string]$LoadAddonsMode = [Devolutions.RemoteDesktopManager.DefaultBoolean]::Default,
        [Devolutions.RemoteDesktopManager.RDPClientSpec]$ClientSpec = [Devolutions.RemoteDesktopManager.RDPClientSpec]::Default,
        [int]$KeepAliveInternal = 1000,
       
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
        Write-Verbose '[New-DSRDPEntry] Beginning...'

    }
    
    PROCESS {

        $ParamList = Get-ParameterValues

        try {
            #Default RDP entry, valid for all RDP type
            $RDPEntry = @{
                connectionType        = 1
                group                 = $ParamList.Group
                name                  = $ParamList.Name
                displayMode           = $ParamList.DisplayMode
                DisplayMonitor        = $ParamList.DisplayMonitor
                displayVirtualDesktop = $ParamList.DisplayVirtualDesktop
                data                  = @{
                    host                        = $ParamList.HostName 
                    adminMode                   = $ParamList.AdminMode
                    rdpType                     = $ParamList.RDPType
                    username                    = $ParamList.Username
                    soundHook                   = $ParamList.SoundHook
                    audioQualityMode            = $ParamList.AudioQualityMode
                    usesClipboard               = $ParamList.UsesClipboard
                    usesDevices                 = $ParamList.UsesDevices
                    usesHardDrives              = $ParamList.UsesHardDrives
                    usesPrinters                = $ParamList.UsesPrinters
                    usesSerialPorts             = $ParamList.UsesSerialPorts
                    usesSmartDevices            = $ParamList.UsesSmartDevices     
                    audioCaptureRedirectionMode = $ParamList.AudioCaptureRedirectionMode
                    connectionType              = $ParamList.NetworkConnectionType
                    videoPlaybackMode           = $ParamList.RedirectVideoPlayback
                    animations                  = $ParamList.Animations
                    loadAddOnsMode              = $ParamList.LoadAddonsMode
                    keyboardHook                = $ParamList.KeyboardHook
                    promptCredentials           = $ParamList.PromptCredentials
                    clientSpec                  = switch ($ParamList.ClientSpec) {
                        { $_ -lt 0 } { $ParamList.ClientSpec }
                        { $_ -gt 1000 } { $ParamList.ClientSpec }
                        Default { $ParamList.ClientSpec }
                    }
                }
            }

            #Create passwordItem if password is present and not null
            if (![string]::IsNullOrWhiteSpace($ParamList.Password)) {
                $RDPEntry.data += @{ 
                    'passwordItem' = @{ 
                        hasSensitiveData = $false
                        sensitiveData    = $ParamList.Password 
                    } 
                }
            }

            #Possible fields for RDP type "Azure"
            if ($ParamList.RDPType -eq [Devolutions.RemoteDesktopManager.RDPType]::Azure) {
                $RDPEntry.data += @{ 'azureInstanceID' = $ParamList.AzureInstanceID }
                $RDPEntry.data += @{ 'azureRoleName' = $ParamList.RoleName }
            }

            #Possible fields for RDP type "HyperV"
            if ($ParamList.RDPType -eq [Devolutions.RemoteDesktopManager.RDPType]::HyperV) {
                $RDPEntry.data += @{ 'hyperVInstanceID' = $ParamList.HyperVInstance }
                $RDPEntry.data += @{ 'useEnhancedSessionMode' = $ParamList.UseEnhancedSessionMode }
            }

            #After login program
            if (![string]::IsNullOrEmpty($ParamList.AfterLoginProgram)) {
                $RDPEntry.data += @{ 'afterLoginExecuteProgram' = $true }
                $RDPEntry.data += @{ 'afterLoginProgram' = $ParamList.AfterLoginProgram }
                $RDPEntry.data += @{
                    'afterLoginDelay' = switch ($ParamList.AfterLoginDelay) {
                        { $_ -lt 0 } { 0 }
                        { $_ -gt 60000 } { 60000 }
                        Default { $ParamList.AfterLoginDelay }
                    }
                }
            }

            #Alternate shell/RemoteApp program. Prioritizing RemoteApp, as it's preferred over alternative shell
            if (![string]::IsNullOrEmpty($ParamList.RemoteApplicationProgram)) {
                $RDPEntry.data += @{ 'remoteApp' = $true }
                $RDPEntry.data += @{ 'remoteApplicationProgram' = $ParamList.RemoteApplicationProgram }
                $RDPEntry.data += @{ 'remoteApplicationCmdLine' = $ParamList.RemoteApplicationCmdLine }
            }
            elseif (![string]::IsNullOrEmpty($ParamList.AlternateShell)) {
                $RDPEntry.data += @{ 'useAlternateShell' = $true }
                $RDPEntry.data += @{ 'alternateShell' = $ParamList.AlternateShell }
                $RDPEntry.data += @{ 'shellWorkingDirectory' = $ParamList.ShellWorkingDirectory }
            }

            #Converts data to JSON, then encrypt the whole thing
            $RDPEntry.data = Protect-ResourceToHexString (ConvertTo-Json $RDPEntry.data)

            $res = New-DSEntryBase -Body $RDPEntry

            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    
    END {
        if ($res.isSuccess) {
            Write-Verbose '[New-DSRPDEntry] Completed successfully!'
        }
        else {
            Write-Verbose '[New-DSRPDEntry] Ended with errors...'
        }
    }
}