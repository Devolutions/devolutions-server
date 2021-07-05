function Update-DSSSHShellEntry {
    <#
        .SYNOPSIS
        Updates an SSH Shell entry.
        .DESCRIPTION
        Updates an SSH Shell entry using supplied parameters.
        .EXAMPLE
        $UpdatedSSHShellEntry = @{
            Name = ...
            Password = ...
            Description = ...
        }
        
        > Update-DSSSHShellEntry @UpdatedSSHShellEntry
    #>
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [guid]$EntryID = $(throw 'No EntryID was provided. You must provid a valid entryID. If you meant to create a new entry, please use New-DSSSHShellEntry'),
        #Entry's location in the vault (Folder name, not ID)
        [string]$Group,
        #Entry's name
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        #Entry's password
        [string]$Password,
        #Entry's description
        [string]$Description,      
        #Entry's tags (Keywords). Each word separeted by a space is considered a keyword.
        [string]$Keywords,
        [ValidateSet(
            [ConnectionDisplayMode]::Embedded,
            [ConnectionDisplayMode]::External
        )]
        #Display mode used by SSH Shell
        [string]$DisplayMode,
        #Display monitor used by SSH Shell
        [DisplayMonitor]$DisplayMonitor,
        #Virtual desktop used by SSH Shell
        [DisplayVirtualDesktop]$DisplayVirtualDesktop,
        #Always prompt for password when checking out
        [bool]$AlwaysAskForPassword,
        #Entry's username
        [string]$Username,

        [ValidateSet(
            [PrivateKeyType]::Data,
            [PrivateKeyType]::NoKey
        )]
        #Private key type (None/Data)
        [string]$PrivateKeyType,
        #Full path to private key (Including .ppk file)
        [string]$PrivateKeyPath,
        #Private key passphrase
        [string]$PrivateKeyPassphrase,
        #Prompt for passphrase when checking out
        [bool]$PrivateKeyPromptForPassphrase,

        #Entry's host name
        [string]$HostName,
        #Entry's host port
        [int]$HostPort,
        #Delay before starting after-connection macros
        [int]$AfterConnectMacroDelay,
        #Macros to run after connection
        [string]$AfterConnectMacros,
        #If it should send 'Enter' input after entering an after-connection macro
        [bool]$AfterConnectMacroEnterAfterCommand,
        #Delay before starting before-disconnect macro
        [int]$BeforeDisconnectMacroDelay,
        #Macros to run before disconnect
        [string]$BeforeDisconnectMacro,
        #If it should send 'Enter' input after entering a before-disconnect macro
        [bool]$beforeDisconnectMacroEnterAfterCommand,
        #Override terminal type
        [string]$OverrideTerminalName,
        #Select terminal encoding
        [TerminalEncoding]$Encoding,
        #Toggle terminal autowrapping
        [TerminalAutoWrap]$AutoWrap,
        #Toggle terminal local echo
        [TerminalLocalEcho]$LocalEcho,
        #Terminal's initial keypad mode (Default/Application/Normal)
        [TerminalKeypadMode]$InitialKeypadMode,
        #Disable terminal application keypad mode
        [DefaultBoolean]$DisableKeypadMode,
        #Select terminal cursor type (Block/Underline/Vertical line) 
        [TerminalCursorType]$CursorType,
        #Toggle terminal cursor blink
        [TerminalCursorBlink]$CursorBlink,
        #Force non-destructive backspaces (Disable character 127)
        [bool]$ForceNonDestructiveBackspace,
        #Convert CR to LF
        [bool]$ImplicitCRinLF,
        #Convert LF to CR
        [bool]$ImplicitLFinCR,
        #Terminal max scrollback lines
        [int]$MaxScrollbackLines,
        #Delemiters for double-clicking in terminal
        [string]$DoubleClickDelimiters,
        #Select font mode (Default/Override)
        [TerminalFontMode]$FontMode,
        #Select bell mode behavior (Default/None/Sound/Visual)
        [TerminalBellMode]$BellMode,
        [string]$RemoteCommand,
        #Keyboard cursor key mode (Default/Normal/Application)
        [TerminalCursorKeyMode]$CursorKeyMode,
        #Keyboard backspace key mode (Default/Control-H/Control-? (ASCII code 127))
        [TerminalBackspaceKeyMode]$BackspaceKeyMode,
        #Keyboard home/end key mode (Default/Standard/RXVT)
        [TerminalHomeEndKeyMode]$HomeEndKeyMode,
        #Keyboard fn key mode
        [TerminalFunctionKeysMode]$FunctionKeyMode,        
    
        [ValidateSet(
            [ProxyMode]::Custom,
            [ProxyMode]::None
        )]
        #Proxy mode (Only None/custom supported)
        [string]$ProxyMode,
        [ValidateSet(
            [ProxyTunnelType]::Socks5,
            [ProxyTunnelType]::Socks4,
            [ProxyTunnelType]::Http
        )]
         #Proxy type
        [string]$ProxyType,
        #Proxy Hostname
        [string]$ProxyHost,
        #Proxy host port
        [string]$ProxyHostPort,
        #Proxy username
        [string]$ProxyUsername,
        #Proxy password
        [string]$ProxyPassword,
        [string]$ProxyLocalHostConnections,
        #Proxy excluded hosts
        [string]$ProxyExcludedHosts,
        #Proxy DNS lookup mode
        [TelnetTerminalDnsLookupType]$ProxyDNSLookupType,
        #Telnet/local proxy command (blank for default)
        [string]$ProxyTelnetCommand,
    
        #Warn if session is already opened
        [bool]$WarnIfAlreadyOpened,
        #Prompt for comment on open
        [bool]$OpenCommentPrompt,
        #Comment is required on open
        [bool]$OpenCommentIsRequired,
        #Ticket number is required on open
        [bool]$TicketNumberIsRequiredOnOpen,
        #Prompt for comment on close
        [bool]$CloseCommentPrompt,
        #Comment is required on close
        [bool]$CloseCommentIsRequired,
        #Ticket number is required on close
        [bool]$TicketNumberIsRequiredOnClose,
        #Prompt when viewing credentials
        [bool]$CredentialViewedPrompt,
        #Prompt for comment when credentials viewed
        [bool]$CredentialViewedCommentIsRequired,
        #Prompt for ticket number on credentials viewed
        [bool]$TicketNumberIsRequiredOnCredentialViewed,
        
        #Add new fields to entry. Used for support if we add more fields in the future and don't have time to update accordingly.
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