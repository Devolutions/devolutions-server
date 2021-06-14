function Update-DSSSHShellEntry {
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [guid]$EntryID = $(throw 'No EntryID was provided. You must provid a valid entryID. If you meant to create a new entry, please use New-DSSSHShellEntry'),

        [string]$Group,
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [string]$Password,
        [string]$Description,
        [string]$Keywords,
        [ValidateSet(
            [ConnectionDisplayMode]::Embedded,
            [ConnectionDisplayMode]::External
        )]
        [string]$DisplayMode,
        [DisplayMonitor]$DisplayMonitor,
        [DisplayVirtualDesktop]$DisplayVirtualDesktop,
    
        [bool]$AlwaysAskForPassword,
        [string]$Username,

        [ValidateSet(
            [PrivateKeyType]::Data,
            [PrivateKeyType]::NoKey
        )]
        [string]$PrivateKeyType,
        [string]$PrivateKeyPath,
        [string]$PrivateKeyPassphrase,
        [bool]$PrivateKeyPromptForPassphrase,

        [string]$HostName,
        [int]$HostPort,
        [int]$AfterConnectMacroDelay,
        [string]$AfterConnectMacros,
        [bool]$AfterConnectMacroEnterAfterCommand,
        [int]$BeforeDisconnectMacroDelay,
        [string]$BeforeDisconnectMacro,
        [bool]$beforeDisconnectMacroEnterAfterCommand,
        [string]$OverrideTerminalName,
        [TerminalEncoding]$Encoding,
        [TerminalAutoWrap]$AutoWrap,
        [TerminalLocalEcho]$LocalEcho,
        [TerminalKeypadMode]$InitialKeypadMode,
        [DefaultBoolean]$DisableKeypadMode,
        [TerminalCursorType]$CursorType,
        [TerminalCursorBlink]$CursorBlink,
        [bool]$ForceNonDestructiveBackspace,
        [bool]$ImplicitCRinLF,
        [bool]$ImplicitLFinCR,
        [int]$MaxScrollbackLines,
        [string]$DoubleClickDelimiters,
        [TerminalFontMode]$FontMode,
        [TerminalBellMode]$BellMode,
        [string]$RemoteCommand,
        [TerminalCursorKeyMode]$CursorKeyMode,
        [TerminalBackspaceKeyMode]$BackspaceKeyMode,
        [TerminalHomeEndKeyMode]$HomeEndKeyMode,
        [TerminalFunctionKeysMode]$FunctionKeyMode,        
    
        [ValidateSet(
            [ProxyMode]::Custom,
            [ProxyMode]::None
        )]
        [string]$ProxyMode,
        [ValidateSet(
            [ProxyTunnelType]::Socks5,
            [ProxyTunnelType]::Socks4,
            [ProxyTunnelType]::Http
        )]
        [string]$ProxyType,
        [string]$ProxyHost,
        [string]$ProxyHostPort,
        [string]$ProxyUsername,
        [string]$ProxyPassword,
        [string]$ProxyLocalHostConnections,
        [string]$ProxyExcludedHosts,
        [TelnetTerminalDnsLookupType]$ProxyDNSLookupType,
        [string]$ProxyTelnetCommand,
    
        [bool]$WarnIfAlreadyOpened,
        [bool]$OpenCommentPrompt,
        [bool]$OpenCommentIsRequired,
        [bool]$TicketNumberIsRequiredOnOpen,
        [bool]$CloseCommentPrompt,
        [bool]$CloseCommentIsRequired,
        [bool]$TicketNumberIsRequiredOnClose,
        [bool]$CredentialViewedPrompt,
        [bool]$CredentialViewedCommentIsRequired,
        [bool]$TicketNumberIsRequiredOnCredentialViewed,

        [Field[]]$NewFieldsList
    )
    
    BEGIN {
        Write-Verbose '[Update-DSSSHShellEntry] Beginning...'

        $PSBoundParameters.Remove('EntryID')
        $PSBoundParameters.Remove('Verbose')
        $PSBoundParameters.Remove('NewFieldsList')

        $RootProperties = @('Group', 'Name', 'DisplayMode', 'DisplayMonitor', 'DisplayVirtualDesktop', 'Description', 'Keywords')
        $EventsProperties = @('WarnIfAlreadyOpened', 'OpenCommentPrompt', 'OpenCommentIsRequired', 'TicketNumberIsRequiredOnOpen', 'CloseCommentPrompt', 'CloseCommentIsRequired', 'TicketNumberIsRequiredOnClose', 'CredentialViewedPrompt', 'CredentialViewedCommentIsRequired', 'TicketNumberIsRequiredOnCredentialViewed')
    }
    
    PROCESS {
        try {
            if (($EntryCtx = Get-DSEntry $EntryID -IncludeAdvancedProperties).isSuccess) {
                $SSHShellEntry = $EntryCtx.Body.data

                if ($SSHShellEntry.connectionType -ne [ConnectionType]::SSHShell) {
                    throw 'Provided entry is not of type SSHShell. Please use the appropriate CMDlet for this entry.'
                }
            }
            else {
                throw "Entry couldn't be found. Please provide a valid entry ID and try again."
            }

            foreach ($param in $PSBoundParameters.GetEnumerator()) {
                #If param is at object's root
                if ($param.Key -in $RootProperties) {
                    switch ($param.Key) {
                        'Name' {
                            if ([string]::IsNullOrEmpty($param.Value)) {
                                Write-Warning '[Update-DSSSHShellEntry] Ignoring Name: Cannot be null or empty.'
                            }
                            else {
                                $SSHShellEntry.name = $param.Value
                            }
                            continue
                        }
                        'Keywords' { 
                            #Detect if strings has something
                            #Split in string array by space
                            #Split new keywords in string array by space
                            #Append new to old string array
                            continue
                        }
                        Default {
                            if ($param.Key -in $SSHShellEntry.PSObject.Properties.Name) {
                                $SSHShellEntry.($param.Key) = $param.Value
                            }
                            else {
                                $SSHShellEntry | Add-Member -NotePropertyName $param.Key -NotePropertyValue $param.Value
                            }
                        }
                    }
                }
                #If param is in object.events
                elseif ($param.Key -in $EventsProperties) {
                    $SSHShellEntry.events | Add-Member -NotePropertyName $param.Key -NotePropertyValue $param.Value -Force
                }
                #If param is in object.data
                else {
                    switch ($param.Key) {
                        'PrivateKeyPath' {
                            $PrivateKeyCtx = Confirm-PrivateKey $param.Value

                            if ($PrivateKeyCtx.Body.result -ne [SaveResult]::Success) {
                                Write-Warning "[Update-DSSSHShellEntry] Error while parsing private key from path $($param.Value). Reverting back to 'No private key'"
                                $tmp = @{
                                    hasSensitiveData = $false
                                    sensitiveData    = ''
                                }
                                
                                $SSHShellEntry.data | Add-Member -NotePropertyName 'privateKeyType' -NotePropertyValue ([PrivateKeyType]::NoKey) -Force
                                $SSHShellEntry.data | Add-Member -NotePropertyName 'privateKeyData' -NotePropertyValue '' -Force
                                $SSHShellEntry.data | Add-Member -NotePropertyName 'privateKeyPassPhraseItem' -NotePropertyValue $tmp -Force
                            }
                            else {
                                $SSHShellEntry.data | Add-Member -NotePropertyName 'privateKeyType' -NotePropertyValue ([PrivateKeyType]::Data) -Force
                                $SSHShellEntry.data | Add-Member -NotePropertyName 'privateKeyData' -NotePropertyValue $PrivateKeyCtx.Body.privateKeyData -Force
                            }
                        }
                        'PrivateKeyPassPhrase' {
                            $tmp = @{
                                hasSensitiveData = $true
                                sensitiveData    = $param.Value
                            }

                            $SSHShellEntry.data | Add-Member -NotePropertyName 'privateKeyPassPhraseItem' -NotePropertyValue $tmp -Force
                        }
                        'ProxyPassword' {
                            $tmp = @{
                                hasSensitiveData = $true
                                sensitiveData    = $param.Value
                            }

                            $SSHShellEntry.data | Add-Member -NotePropertyName 'proxyPasswordItem' -NotePropertyValue $tmp -Force
                        }
                        'Password' {
                            $SSHShellEntry.data.passwordItem = @{
                                hasSensitiveData = $true
                                sensitiveData    = $param.Value
                            }
                        }
                        'HostName' {
                            $SSHShellEntry.data | Add-Member -NotePropertyName 'host' -NotePropertyValue $param.Value -Force
                        }
                        Default {
                            $SSHShellEntry.data | Add-Member -NotePropertyName $param.Key -NotePropertyValue $param.Value -Force
                        }
                    }
                }
            }

            foreach ($Param in $NewFieldsList.GetEnumerator()) {
                switch ($Param.Depth) {
                    'root' { $SSHShellEntry | Add-Member -NotePropertyName $param.Name -NotePropertyValue $param.Value -Force } 
                }
                default {
                    if ($SSHShellEntry.($Param.Depth)) {
                        $SSHShellEntry.($param.Depth) | Add-Member -NotePropertyName $param.Name -NotePropertyValue $param.Value -Force
                    }
                    else {
                        $SSHShellEntry | c Add-Member -NotePropertyName $param.Depth -NotePropertyValue $null -Force
                        $SSHShellEntry.($param.Depth) | Add-Member -NotePropertyName $param.Name -NotePropertyValue $param.Value -Force
                    }
                }
            }

            $SSHShellEntry.data = Protect-ResourceToHexString (ConvertTo-Json $SSHShellEntry.data)

            $res = Update-DSEntryBase -jsonBody (ConvertTo-Json $SSHShellEntry)
            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    
    END {
        if ($res.isSuccess) {
            Write-Verbose '[Update-DSSSHShellEntry] Completed successfully!'

        }
        else {
            Write-Verbose '[Update-DSSSHShellEntry] Ended with errors...'
        }
    }
}