function Update-DSRDPEntry {
    <#
        .SYNOPSIS

        .DESCRIPTION

        .EXAMPLE

    #>
    [CmdletBinding()]
    PARAM (
        [guid]$EntryID = $(throw 'Entry ID is null or empty. Please provide a valid RDP entry ID and try again.'),
        [bool]$ForceAlternateShellProgram = $false,

        #Entry's name
        [string]$Name,
        #Entry's domain
        [string]$Domain,
        #Entry's username
        [string]$Username,
        #Entry's password
        [string]$Password,
        #Entry's mnemonic passwordF
        [string]$MnemonicPassword,
        #Entry's vault ID
        [guid]$VaultID,
        #Entry's location in the vault (Folder name, not ID)
        [string]$Group,
        #Entry's prompt for password when checkout
        [bool]$PromptCredentials,
    
        #Entry's description
        [string]$Description,
        #Entry's tags (Keywords). Each word separeted by a space is considered a keyword.
        [string]$Tags,
        #Entry's expiration date (ISO-8601 format (yyyy-mm-ddThh:mm:ss.000Z)
        [string]$Expiration,

        #A comment is required to view entry's credentials
        [bool]$CredentialViewedCommentIsRequired,
        #A ticket number is required to view entry's credentials
        [bool]$TicketNumberIsRequiredOnCredentialViewed,
        #Prompt the user for comment/ticket number
        [bool]$CredentialViewedPrompt,

        #Entry's checkout mode
        [Devolutions.RemoteDesktopManager.CheckOutMode]$CheckoutMode,
        #Entry's offline mode
        [Devolutions.RemoteDesktopManager.AllowOffline]$AllowOffline,

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
        [ValidateSet(
            [Devolutions.RemoteDesktopManager.KeyboardHook]::OnTheLocalComputer,
            [Devolutions.RemoteDesktopManager.KeyboardHook]::InFullScreenMode,
            [Devolutions.RemoteDesktopManager.KeyboardHook]::OnTheRemoteComputer
        )]
        [string]$KeyboardHook,

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
        [Devolutions.RemoteDesktopManager.RDPClientSpec]$ClientSpec,
        [int]$KeepAliveInternal,
       
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
        Write-Verbose '[Update-DSRDPEntry] Beginning...'

        $PSBoundParameters.Remove('EntryID')
        $PSBoundParameters.Remove('Verbose')
        
        $RootProperties = @('Group', 'Name', 'DisplayMode', 'DisplayMonitor', 'DisplayVirtualDesktop')
        $ProgramTabProperties = @('AfterLoginProgram', 'AfterLoginDelay', 'RemoteApplicationProgram', 'RemoteApplicationCmdLine', 'AlternateShell', 'ShellWorkingDirectory')
    }
    
    PROCESS {
        try {
            $VeryTempUselessVar = $PSBoundParameters
            if (($EntryCtx = Get-DSEntry $EntryID -IncludeAdvancedProperties).isSuccess) {
                $RDPEntry = $EntryCtx.Body.data

                if ($RDPEntry.connectionType -ne [Devolutions.RemoteDesktopManager.ConnectionType]::RDPConfigured) {
                    throw 'Provided entry is not of type RDPConfigured. Please use the appropriate CMDlet for this entry.'
                }
            }
            else {
                throw "Entry couldn't be found. Please provide a valid entry ID and try again."
            }

            foreach ($param in $PSBoundParameters.GetEnumerator()) {
                #Parameter is in root of partialConnection
                if ($param.Key -in $RootProperties) {
                    switch ($param.Key -in $RDPEntry.PSObject.Properties.Name) {
                        $true { $RDPEntry.($param.Key) = $param.Value; break }
                        $false { $RDPEntry | Add-Member -NotePropertyName $param.Key -NotePropertyValue $param.Value; break }
                        Default { Write-Warning "[Update-DSRDPEntry] Error with param: $($param.Key)"; break }
                    }
                }
                #Parameter is in partialConnection.data
                else {
                    switch ($param.Key) {
                        'Password' { 
                            $RDPEntrySensitiveData = (Get-DSEntrySensitiveData $EntryID).Body.data

                            $RDPEntry.data.passwordItem = @{
                                hasSensitiveData = $true
                                sensitiveData    = ($param.Value, $RDPEntrySensitiveData.Credentials.Password)[!($param.Value -ne $RDPEntrySensitiveData.Credentials.Password)]
                            }
                        }

                        { $_ -in @('AfterLoginProgram') } {
                            #Check if entry already has an after login program
                            if ($RDPEntry.data.afterLoginProgram) {
                                #If AfterLoginProgram is empty, meaning user meant to delete it
                                if ($param.Value -eq '') {
                                    $RDPEntry.data.afterLoginExecuteProgram = $false
                                }
                                #If it's not empty, meaning user meant to update value
                                else {
                                    $RDPEntry.data.afterLoginProgram = $param.Value
                                    $RDPEntry.data.afterLoginDelay = if ('AfterLoginDelay' -in $PSBoundParameters.PSObject.Properties.Name) {
                                        switch ($PSBoundParameters['AfterLoginDelay']) {
                                            { $_.value -lt 0 } { 500 }
                                            { $_ -gt 60000 } { 60000 }
                                            default { $PSBoundParameters['AfterLoginDelay'] }
                                        }
                                    }
                                    elseif ($RDPEntry.data.afterLoginDelay) {
                                        $RDPEntry.data.afterLoginDelay
                                    }
                                    else {
                                        500
                                    }
                                }
                            }
                            #Entry doesn't have after login program
                            else {
                                $AfterLoginDelay = switch ($PSBoundParameters['afterLoginDelay']) {
                                    $null { if ($RDPEntry.data.afterDelayLogin) { $RDPEntry.data.afterDelayLogin } else { 500 } }
                                    { $_ -lt 0 } { 0 }
                                    { $_ -gt 60000 } { 60000 }
                                    default { $PSBoundParameters['afterLoginDelay'] }
                                }                               

                                $RDPEntry.data | Add-Member -NotePropertyName 'afterLoginExecuteProgram' -NotePropertyValue $true
                                $RDPEntry.data | Add-Member -NotePropertyName 'afterLoginProgram' -NotePropertyValue $param.Value
                                $RDPEntry.data | Add-Member -NotePropertyName 'afterLoginDelay' -NotePropertyValue $AfterLoginDelay
                            }
                        }

                        { $_ -in @('RemoteApplicationProgram') } {
                            if ($RDPEntry.data.remoteApplicationProgram) {
                                if ($param.Value -eq '') {
                                    $RDPEntry.data.remoteApp = $false
                                }
                                else {
                                    $RDPEntry.data.remoteApplicationProgram = $param.Value
                                }
                            }
                            else {
                                $RDPEntry.data | Add-Member -NotePropertyName 'remoteApp' -NotePropertyValue $true
                                $RDPEntry.data | Add-Member -NotePropertyName 'remoteApplicationProgram' -NotePropertyValue $param.Value
                            }
                        }

                        { $_ -in @('AlternateShell') } {
                            if ($RDPEntry.data.remoteApplicationProgram) {
                                if ($ForceAlternateShellProgram) {
                                    $RDPEntry.data.remoteApp = $false
                                    $RDPEntry.data | Add-Member -NotePropertyName 'useAlternateShell' -NotePropertyValue $true
                                    $RDPEntry.data | Add-Member -NotePropertyName 'alternateShell' -NotePropertyValue $param.Value
                                }
                                else {
                                    Write-Warning '[Update-DSRDPEntry] RemoteApp is preferred over launching program in alternate shell. If using alternate shell is the desired outcome, try again with -ForceAlternateShellProgram parameter.'
                                }
                            }
                            else {
                                $RDPEntry.data | Add-Member -NotePropertyName 'useAlternateShell' -NotePropertyValue $true
                                $RDPEntry.data | Add-Member -NotePropertyName 'alternateShell' -NotePropertyValue $param.Value
                            }
                        }
                         
                        Default {
                            switch ($param.Key -in $RDPEntry.data.PSObject.Properties.Name) {
                                $true { $RDPEntry.data.($param.Key) = $param.Value; break }
                                $false { $RDPEntry.data | Add-Member -NotePropertyName $param.Key -NotePropertyValue $param.Value; break }
                                Default { Write-Warning "[Update-DSRDPEntry] Error with param: $($param.Key)"; break }
                            }
                        }
                    }
                }
            }

            $RDPEntry.data = Protect-ResourceToHexString (ConvertTo-Json $RDPEntry.data)

            $res = Update-DSEntryBase -jsonBody (ConvertTo-Json $RDPEntry)
            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    
    END {
        if ($res.isSuccess) {
            Write-Verbose '[Update-DSRDPEntry] Completed successfully!'
        }
        else {
            Write-Verbose '[Update-DSRDPEntry] Ended with errors...'
        }
    }
}