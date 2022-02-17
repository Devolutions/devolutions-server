function New-DSSSHShellEntry {
    <#
        .SYNOPSIS
        Creates a new SSH Shell entry
        .DESCRIPTION
        Creates a new SSH Shell entry using supplied parameters. New fields in RDM are automatically supported with the 'NewFieldsList' parameter (Look at 'Field.ps1' for usage)
        .EXAMPLE
        $NewSSHShellEntry = @{
            Name = ...
            Password = ...
            Description = ...
        }

        > New-DSSSHShellEntry @NewSSHShellEntry
    #>
    [CmdletBinding()]
    PARAM (
        #Entry's location in the vault (Folder name, not ID)
        [string]$Group = '',
        #Entry's name
        [ValidateNotNullOrEmpty()]
        [string]$Name = $(throw 'Name is null or empty. Please provide a name for this new entry and try again.'),
        #Entry's password
        [string]$Password = '',
        #Entry's description
        [string]$Description = '',
        #Entry's keywords (Each words separrated by spaces will count as a new keyword.)
        [string]$Keywords = '',
        #Display mode used by SSHShell
        [ValidateSet(
            [ConnectionDisplayMode]::Embedded,
            [ConnectionDisplayMode]::External
        )]
        [string]$DisplayMode = [ConnectionDisplayMode]::Embedded,
        #Display monitor used by SSHShell
        [DisplayMonitor]$DisplayMonitor = [DisplayMonitor]::Primary,
        #Virtual desktop used by SSHShell
        [DisplayVirtualDesktop]$DisplayVirtualDesktop = [DisplayVirtualDesktop]::Default,
        [Guid]$VaultId,
        #If it should always ask for password when checking out
        [bool]$AlwaysAskForPassword = $false,
        #Entry's username
        [string]$Username = '',

        #Private key type
        [ValidateSet(
            [PrivateKeyType]::Data,
            [PrivateKeyType]::NoKey
        )]
        [string]$PrivateKeyType = [PrivateKeyType]::NoKey,
        #Full path to private key, including .ppk file
        [string]$PrivateKeyPath = '',
        #Passphrase for private key
        [string]$PrivateKeyPassphrase = '',
        #If it should prompt for passphrase when checking out
        [bool]$PromptForPassphrase = '',

        #Entry's hostname
        [string]$HostName = '',
        #Entry's host port
        [int]$HostPort = 22,
        #Delay before starting after-connection macros
        [int]$AfterConnectMacroDelay = 500,
        #Macros to run after connection
        [string]$AfterConnectMacros = '',
        #If it should send 'Enter' input after entering an after-connection macro
        [bool]$AfterConnectMacroEnterAfterCommand = $true,
        #Delay before starting before-disconnect macro
        [int]$BeforeDisconnectMacroDelay = 500,
        #Macros to run before disconnect
        [string]$BeforeDisconnectMacro = '',
        #If it should send 'Enter' input after entering a before-disconnect macro
        [bool]$beforeDisconnectMacroEnterAfterCommand = $true,
        #Override terminal type
        [string]$OverrideTerminalName = '',
        #Select terminal encoding
        [TerminalEncoding]$Encoding = [TerminalEncoding]::Default,
        #Toggle terminal autowrapping
        [TerminalAutoWrap]$AutoWrap = [TerminalAutoWrap]::Default,
        #Toggle terminal local echo
        [TerminalLocalEcho]$LocalEcho = [TerminalLocalEcho]::Default,
        #Terminal's initial keypad mode (Default/Application/Normal)
        [TerminalKeypadMode]$InitialKeypadMode = [TerminalKeypadMode]::Default,
        #Disable terminal application keypad mode
        [DefaultBoolean]$DisableKeypadMode = [DefaultBoolean]::Default,
        #Select terminal cursor type (Block/Underline/Vertical line) 
        [TerminalCursorType]$CursorType = [TerminalCursorType]::Default,
        #Toggle terminal cursor blink
        [TerminalCursorBlink]$CursorBlink = [TerminalCursorBlink]::Default,
        #Force non-destructive backspaces (Disable character 127)
        [bool]$ForceNonDestructiveBackspace = $false,
        #Convert CR to LF
        [bool]$ImplicitCRinLF = $false,
        #Convert LF to CR
        [bool]$ImplicitLFinCR = $false,
        #Terminal max scrollback lines
        [int]$MaxScrollbackLines = 2000,
        #Delemiters for double-clicking in terminal
        [string]$DoubleClickDelimiters = '',
        #Select font mode (Default/Override)
        [TerminalFontMode]$FontMode = [TerminalFontMode]::Default,
        #Select bell mode behavior (Default/None/Sound/Visual)
        [TerminalBellMode]$BellMode = [TerminalBellMode]::Default,
        #Absolute path of the application on the remote computer
        [string]$RemoteCommand = '',
        #Keyboard cursor key mode (Default/Normal/Application)
        [TerminalCursorKeyMode]$CursorKeyMode = [TerminalCursorKeyMode]::Default,
        #Keyboard backspace key mode (Default/Control-H/Control-? (ASCII code 127))
        [TerminalBackspaceKeyMode]$BackspaceKeyMode = [TerminalBackspaceKeyMode]::Default,
        #Keyboard home/end key mode (Default/Standard/RXVT)
        [TerminalHomeEndKeyMode]$HomeEndKeyMode = [TerminalHomeEndKeyMode]::Default,
        #Keyboard fn key mode
        [TerminalFunctionKeysMode]$FunctionKeyMode = [TerminalFunctionKeysMode]::Default,        
    
        #Proxy mode (Only None/custom supported)
        [ValidateSet(
            [ProxyMode]::Custom,
            [ProxyMode]::None
        )]
        [string]$ProxyMode = [ProxyMode]::None,
        #Proxy type
        [ValidateSet(
            [ProxyTunnelType]::Socks5,
            [ProxyTunnelType]::Socks4,
            [ProxyTunnelType]::Http
        )]
        [string]$ProxyType = [ProxyTunnelType]::Socks5,
        #Proxy Hostname
        [string]$ProxyHost = '',
        #Proxy host port
        [string]$ProxyHostPort = 0,
        #Proxy username
        [string]$ProxyUsername = '',
        #Proxy password
        [string]$ProxyPassword = '',
        [string]$ProxyLocalHostConnections = '',
        #Proxy excluded hosts
        [string]$ProxyExcludedHosts = '',
        #Proxy DNS lookup mode
        [TelnetTerminalDnsLookupType]$ProxyDNSLookupType = [TelnetTerminalDnsLookupType]::Automatic,
        #Telnet/local proxy command (blank for default)
        [string]$ProxyTelnetCommand = '',
    
        #Warn if session is already opened
        [bool]$WarnIfAlreadyOpened = $false,
        #Prompt for comment on open
        [bool]$OpenCommentPrompt = $false,
        #Comment is required on open
        [bool]$OpenCommentIsRequired = $false,
        #Ticket number is required on open
        [bool]$TicketNumberIsRequiredOnOpen = $false,
        #Prompt for comment on close
        [bool]$CloseCommentPrompt = $false,
        #Comment is required on close
        [bool]$CloseCommentIsRequired = $false,
        #Ticket number is required on close
        [bool]$TicketNumberIsRequiredOnClose = $false,
        #Prompt when viewing credentials
        [bool]$CredentialViewedPrompt = $false,
        #Prompt for comment when credentials viewed
        [bool]$CredentialViewedCommentIsRequired = $false,
        #Prompt for ticket number on credentials viewed
        [bool]$TicketNumberIsRequiredOnCredentialViewed = $false,

        #Add new fields to entry. Used for support if we add more fields in the future and don't have time to update accordingly.
        [Field[]]$NewFieldsList
    )
    
    BEGIN {
        Write-Verbose '[New-DSSSHShellEntry] Beginning...'

        $URI = "$env:DS_URL/api/connections/partial/save"
        
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        try {
            $SSHShell = @{
                connectionType        = [ConnectionType]::SSHShell
                group                 = $Group
                name                  = $Name
                description           = $Description
                keywords              = $Keywords
                displayMode           = $DisplayMode
                DisplayMonitor        = $DisplayMonitor
                displayVirtualDesktop = $DisplayVirtualDesktop
                repositoryID = $VaultId
                data                  = @{
                    alwaysAskForPassword                   = $AlwaysAskForPassword
                    username                               = $Username
                    privateKeyType                         = $PrivateKeyType
                    host                                   = $Hostname
                    hostPort                               = $HostPort
                    afterConnectMacroDelay                 = ( { 500 }, $AfterConnectMacroDelay )[!($AfterConnectMacroDelay -lt 500)]
                    afterConnectMacros                     = $AfterConnectMacros
                    afterConnectMacroEnterAfterCommand     = $afterConnectMacroEnterAfterCommand
                    beforeDisconnectMacroDelay             = ( { 500 }, $BeforeDisconnectMacroDelay )[!($BeforeDisconnectMacroDelay -lt 500)]
                    beforeDisconnectMacroEnterAfterCommand = $beforeDisconnectMacroEnterAfterCommand
                    beforeDisconnectMacro                  = $BeforeDisconnectMacro
                    overrideTerminalName                   = $OverrideTerminalName
                    encoding                               = $Encoding
                    autoWrap                               = $AutoWrap
                    localEcho                              = $LocalEcho
                    initialKeypadMode                      = $InitialKeypadMode
                    disableKeypadMode                      = $DisableKeypadMode
                    cursorType                             = $CursorType
                    cursorBlink                            = $CursorBlink
                    forceNonDestructiveBackspace           = $ForceNonDestructiveBackspace
                    implicitCRinLF                         = $ImplicitCRinLF
                    implicitLFinCR                         = $ImplicitLFinCR
                    maxScrollbackLines                     = $MaxScrollbackLines
                    doubleClickDelimiters                  = $DoubleClickDelimiters
                    fontMode                               = $FontMode
                    bellMode                               = $BellMode
                    cursorKeyMode                          = $CursorKeyMode
                    backspaceKeyMode                       = $BackspaceKeyMode
                    homeEndKeyMode                         = $HomeEndKeyMode
                    functionKeyMode                        = $FunctionKeyMode
                    proxyMode                              = $ProxyMode
                    proxyType                              = $ProxyType
                }
                event                 = @{
                    WarnIfAlreadyOpened                      = $WarnIfAlreadyOpened
                    OpenCommentPrompt                        = $OpenCommentPrompt
                    OpenCommentIsRequired                    = $OpenCommentIsRequired
                    TicketNumberIsRequiredOnOpen             = $TicketNumberIsRequiredOnOpen
                    CloseCommentPrompt                       = $CloseCommentPrompt
                    CloseCommentIsRequired                   = $CloseCommentIsRequired
                    TicketNumberIsRequiredOnClose            = $TicketNumberIsRequiredOnClose
                    CredentialViewedPrompt                   = $CredentialViewedPrompt
                    CredentialViewedCommentIsRequired        = $CredentialViewedCommentIsRequired
                    TicketNumberIsRequiredOnCredentialViewed = $TicketNumberIsRequiredOnCredentialViewed
                }
            }

            if ($Password) {
                $SSHShell.data += @{
                    passwordItem = @{
                        hasSensitiveData = $true
                        sensitiveData    = $Password
                    }
                }
            }

            #Check for new parameters
            if ($NewFieldsList.Count -gt 0) {
                foreach ($Param in $NewFieldsList.GetEnumerator()) {
                    switch ($Param.Depth) {
                        'root' { $SSHShell += @{$Param.Name = $Param.Value } }
                        default {
                            if ($SSHShell.($Param.Depth)) {
                                $SSHShell.($Param.Depth) += @{ $Param.Name = $param.value }
                            }
                            else {
                                $SSHShell += @{
                                    $Param.Depth = @{
                                        $Param.Name = $Param.Value
                                    }
                                }
                            }
                        }
                    }
                }
            }

            #Handling general/private key
            switch ($PrivateKeyType) {
                'Data' {
                    #Validate private key, if path was provided
                    if (![string]::IsNullOrEmpty($PrivateKeyPath)) { 
                        $PrivateKeyCtx = Confirm-PrivateKey $PrivateKeyPath
                        if ($PrivateKeyCtx.Body.result -ne [SaveResult]::Success) {
                            throw [System.Management.Automation.ItemNotFoundException]::new('Private key could not be parsed. Please make sure you provide a valid .ppk file.') 
                        } 
                        
                        $SSHShell.data += @{ privateKeyData = $PrivateKeyCtx.Body.privateKeyData }

                        if ($PrivateKeyPassphrase) {
                            $SSHShell.data += @{
                                privateKeyPassPhraseItem = @{
                                    hasSensitiveData = $true
                                    sensitiveData    = $PrivateKeyPassphrase
                                }
                            }
                        }

                        if ($PromptForPassphrase) {
                            $SSHShell += @{ privateKeyPromptForPassPhrase = $PromptForPassphrase }
                        }
                    }   
                }
                'NoKey' {  }
                Default { Write-Warning "[New-DSSSHShellEntry] Unsupported private key type. Supported types are : 'NoKey' and 'Data'." }
            }

            #Handling general/proxy
            switch ($ProxyMode) {
                'None' {
                    $SSHShell.data += @{ roxyMode = $ProxyMode } 
                }
                'Custom' {  
                    $SSHShell.data += @{ 
                        roxyMode                  = $ProxyMode
                        proxyHost                 = $ProxyHost
                        proxyHostPort             = $ProxyHostPort
                        proxyUserName             = $ProxyUsername
                        proxyLocalHostConnections = $ProxyLocalHostConnections
                        proxyExcludedHosts        = $ProxyExcludedHosts
                        proxyDnsLookupType        = $ProxyDNSLookupType
                        proxyTelnetCommand        = $ProxyTelnetCommand
                    }

                    if ($ProxyPassword) {
                        $SSHShell.data += @{ 
                            proxyPasswordItem = @{
                                hasSensitiveData = $true
                                sensitiveData    = $ProxyPassword
                            }
                        }
                    }
                }
            }

            $res = New-DSEntryBase -JsonBody (ConvertTo-Json $SSHShell)
            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    
    END {
        if ($res.isSuccess) {
            Write-Verbose '[New-DSSSHShellEntry] Completed successfully!'
        }
        else {
            Write-Verbose '[New-DSSSHShellEntry] Ended with errors...'
        }
    }
}