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
        
        #Warns the user if RDP session is already opened
        [bool]$WarnIfAlreadyOpened = $False,
        #A comment is required to view entry's credentials
        [bool]$CredentialViewedCommentIsRequired = $False,
        #A ticket number is required to view entry's credentials
        [bool]$TicketNumberIsRequiredOnCredentialViewed = $False,
        #Prompt the user for comment/ticket number on credential viewed
        [bool]$CredentialViewedPrompt = $False,
        #Prompt the user for comment/ticket number on open
        [bool]$OpenCommentPrompt = $False,
        #A comment is required on open
        [bool]$OpenCommentIsRequired = $False,
        #A ticket number is required on open
        [bool]$TicketNumberIsRequiredOnOpen = $False,
        #Prompt the user for comment/ticket number on close
        [bool]$CloseCommentPrompt = $False,
        #A comment is required on close
        [bool]$CloseCommentIsRequired = $False,
        #A ticket number is required on close
        [bool]$TicketNumberIsRequiredOnClose = $False,

        <# -- Security tab -- #>

        #Entry's checkout mode
        [CheckOutMode]$CheckoutMode = [CheckOutMode]::Default,
        #Entry's offline mode
        [AllowOffline]$AllowOffline = [AllowOffline]::Default,

        <# -- RDP entry specifics... -- #>

        #RDP's host name (Address)
        [string]$HostName,
        #Opens the adminstration console
        [bool]$AdminMode = $False,
        #Port used by RDP
        [string]$Port = '3389',
        #RDP Type
        [RDPType]$RDPType = [RDPType]::Normal,
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
        [SoundHook]$SoundHook = [SoundHook]::BringToThisComputer,
        #RDP Audio quality
        [RDPAudioQualityMode]$AudioQualityMode = [RDPAudioQualityMode]::Dynamic,
        #Record audio from RDP session
        [bool]$AudioCaptureRedirectionMode = $true,
        #Sets the destination for Windows key combinations (ALT+TAB, for example)
        [ValidateSet(
            [KeyboardHook]::OnTheLocalComputer,
            [KeyboardHook]::InFullScreenMode,
            [KeyboardHook]::OnTheRemoteComputer
        )]
        [string]$KeyboardHook = [KeyboardHook]::OnTheLocalComputer,

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
        [string]$NetworkConnectionType = [RDPNetworkConnectionType]::Default,
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
            [DefaultBoolean]::Default,
            [DefaultBoolean]::True,
            [DefaultBoolean]::False
        )]
        #Sets if addons load in embedded or not
        [DefaultBoolean]$LoadAddonsMode = [DefaultBoolean]::Default,
        [RDPClientSpec]$ClientSpec = [RDPClientSpec]::Default,
        [int]$KeepAliveInternal = 1000,
       
        <# -- User interface tab -- #>

        [ValidateSet(
            [ConnectionDisplayMode]::External, 
            [ConnectionDisplayMode]::Embedded,
            [ConnectionDisplayMode]::Undocked     
        )]
        #Display mode used by RDP
        [string]$DisplayMode = [ConnectionDisplayMode]::Embedded,
        #Display monitor used by RDP
        [DisplayMonitor]$DisplayMonitor = [DisplayMonitor]::Primary,
        #Virtual desktop used by RPD
        [DisplayMonitor]$DisplayVirtualDesktop = [DisplayVirtualDesktop]::Current,

        [Field[]]$NewFieldsList
    )

    BEGIN {
        Write-Verbose '[New-DSRDPEntry] Beginning...'
    }
    
    PROCESS {
        try {
            #Default RDP entry, valid for all RDP type
            $RDPEntry = @{
                connectionType        = 1
                group                 = $Group
                name                  = $Name
                displayMode           = $DisplayMode
                DisplayMonitor        = $DisplayMonitor
                displayVirtualDesktop = $DisplayVirtualDesktop
                data                  = @{
                    host                        = $HostName 
                    adminMode                   = $AdminMode
                    rdpType                     = $RDPType
                    username                    = $Username
                    soundHook                   = $SoundHook
                    audioQualityMode            = $AudioQualityMode
                    usesClipboard               = $UsesClipboard
                    usesDevices                 = $UsesDevices
                    usesHardDrives              = $UsesHardDrives
                    usesPrinters                = $UsesPrinters
                    usesSerialPorts             = $UsesSerialPorts
                    usesSmartDevices            = $UsesSmartDevices     
                    audioCaptureRedirectionMode = $AudioCaptureRedirectionMode
                    connectionType              = $NetworkConnectionType
                    videoPlaybackMode           = $RedirectVideoPlayback
                    animations                  = $Animations
                    loadAddOnsMode              = $LoadAddonsMode
                    keyboardHook                = $KeyboardHook
                    promptCredentials           = $PromptCredentials
                    clientSpec                  = switch ($ClientSpec) {
                        { $_ -lt 0 } { $ClientSpec }
                        { $_ -gt 1000 } { $ClientSpec }
                        Default { $ClientSpec }
                    }
                }
                events                = @{
                    credentialViewedCommentIsRequired        = $CredentialViewedCommentIsRequired
                    ticketNumberIsRequiredOnCredentialViewed = $TicketNumberIsRequiredOnCredentialViewed
                    credentialViewedPrompt                   = $CredentialViewedPrompt
                    openCommentPrompt                        = $OpenCommentPrompt
                    openCommentIsRequired                    = $OpenCommentIsRequired
                    ticketNumberIsRequiredOnOpen             = $TicketNumberIsRequiredOnOpen
                    closeCommentPrompt                       = $CloseCommentPrompt
                    closeCommentIsRequired                   = $CloseCommentIsRequired
                    ticketNumberIsRequiredOnClose            = $TicketNumberIsRequiredOnClose
                }
            }

            #Create passwordItem if password is present and not null
            if (![string]::IsNullOrWhiteSpace($Password)) {
                $RDPEntry.data += @{ 
                    'passwordItem' = @{ 
                        hasSensitiveData = $false
                        sensitiveData    = $Password 
                    } 
                }
            }

            #Possible fields for RDP type "Azure"
            if ($RDPType -eq [RDPType]::Azure) {
                $RDPEntry.data += @{ 'azureInstanceID' = $AzureInstanceID }
                $RDPEntry.data += @{ 'azureRoleName' = $RoleName }
            }

            #Possible fields for RDP type "HyperV"
            if ($RDPType -eq [RDPType]::HyperV) {
                $RDPEntry.data += @{ 'hyperVInstanceID' = $HyperVInstance }
                $RDPEntry.data += @{ 'useEnhancedSessionMode' = $UseEnhancedSessionMode }
            }

            #After login program
            if (![string]::IsNullOrEmpty($AfterLoginProgram)) {
                $RDPEntry.data += @{ 'afterLoginExecuteProgram' = $true }
                $RDPEntry.data += @{ 'afterLoginProgram' = $AfterLoginProgram }
                $RDPEntry.data += @{
                    'afterLoginDelay' = switch ($AfterLoginDelay) {
                        { $_ -lt 0 } { 0 }
                        { $_ -gt 60000 } { 60000 }
                        Default { $AfterLoginDelay }
                    }
                }
            }

            #Alternate shell/RemoteApp program. Prioritizing RemoteApp, as it's preferred over alternative shell
            if (![string]::IsNullOrEmpty($RemoteApplicationProgram)) {
                $RDPEntry.data += @{ 'remoteApp' = $true }
                $RDPEntry.data += @{ 'remoteApplicationProgram' = $RemoteApplicationProgram }
                $RDPEntry.data += @{ 'remoteApplicationCmdLine' = $RemoteApplicationCmdLine }
            }
            elseif (![string]::IsNullOrEmpty($AlternateShell)) {
                $RDPEntry.data += @{ 'useAlternateShell' = $true }
                $RDPEntry.data += @{ 'alternateShell' = $AlternateShell }
                $RDPEntry.data += @{ 'shellWorkingDirectory' = $ShellWorkingDirectory }
            }

            #Check for new parameters
            if ($NewFieldsList.Count -gt 0) {
                foreach ($Param in $NewFieldsList.GetEnumerator()) {
                    switch ($Param.Depth) {
                        'root' { $RDPEntry += @{$Param.Name = $Param.Value } }
                        default {
                            if ($RDPEntry.($Param.Depth)) {
                                $RDPEntry.($Param.Depth) += @{ $Param.Name = $param.value }
                            }
                            else {
                                $RDPEntry += @{
                                    $Param.Depth = @{
                                         $Param.Name = $Param.Value
                                    }
                                }
                            }
                        }
                    }
                }
            }

            #Converts data to JSON, then encrypt the whole thing
            $RDPEntry.data = Protect-ResourceToHexString (ConvertTo-Json $RDPEntry.data -Depth 100)

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