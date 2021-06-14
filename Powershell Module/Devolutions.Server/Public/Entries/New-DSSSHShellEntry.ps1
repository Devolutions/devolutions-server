function New-DSSSHShellEntry {
    <#
        .SYNOPSIS

        .DESCRIPTION

        .EXAMPLE
    #>
    [CmdletBinding()]
    PARAM (
        [string]$Group = '',
        [ValidateNotNullOrEmpty()]
        [string]$Name = $(throw 'Name is null or empty. Please provide a name for this new entry and try again.'),
        [string]$Password = '',
        [string]$Description = '',
        [string]$Keywords = '',
        [ValidateSet(
            [ConnectionDisplayMode]::Embedded,
            [ConnectionDisplayMode]::External
        )]
        [string]$DisplayMode = [ConnectionDisplayMode]::Embedded,
        [DisplayMonitor]$DisplayMonitor = [DisplayMonitor]::Primary,
        [DisplayVirtualDesktop]$DisplayVirtualDesktop = [DisplayVirtualDesktop]::Default,
    
        [bool]$AlwaysAskForPassword = $false,
        [string]$Username = '',

        [ValidateSet(
            [PrivateKeyType]::Data,
            [PrivateKeyType]::NoKey
        )]
        [string]$PrivateKeyType = [PrivateKeyType]::NoKey,
        [string]$PrivateKeyPath = '',
        [string]$PrivateKeyPassphrase = '',
        [bool]$PromptForPassphrase = '',

        [string]$HostName = '',
        [int]$HostPort = 22,
        [int]$AfterConnectMacroDelay = 500,
        [string]$AfterConnectMacros = '',
        [bool]$AfterConnectMacroEnterAfterCommand = $true,
        [int]$BeforeDisconnectMacroDelay = 500,
        [string]$BeforeDisconnectMacro = '',
        [bool]$beforeDisconnectMacroEnterAfterCommand = $true,
        [string]$OverrideTerminalName = '',
        [TerminalEncoding]$Encoding = [TerminalEncoding]::Default,
        [TerminalAutoWrap]$AutoWrap = [TerminalAutoWrap]::Default,
        [TerminalLocalEcho]$LocalEcho = [TerminalLocalEcho]::Default,
        [TerminalKeypadMode]$InitialKeypadMode = [TerminalKeypadMode]::Default,
        [DefaultBoolean]$DisableKeypadMode = [DefaultBoolean]::Default,
        [TerminalCursorType]$CursorType = [TerminalCursorType]::Default,
        [TerminalCursorBlink]$CursorBlink = [TerminalCursorBlink]::Default,
        [bool]$ForceNonDestructiveBackspace = $false,
        [bool]$ImplicitCRinLF = $false,
        [bool]$ImplicitLFinCR = $false,
        [int]$MaxScrollbackLines = 2000,
        [string]$DoubleClickDelimiters = '',
        [TerminalFontMode]$FontMode = [TerminalFontMode]::Default,
        [TerminalBellMode]$BellMode = [TerminalBellMode]::Default,
        [string]$RemoteCommand = '',
        [TerminalCursorKeyMode]$CursorKeyMode = [TerminalCursorKeyMode]::Default,
        [TerminalBackspaceKeyMode]$BackspaceKeyMode = [TerminalBackspaceKeyMode]::Default,
        [TerminalHomeEndKeyMode]$HomeEndKeyMode = [TerminalHomeEndKeyMode]::Default,
        [TerminalFunctionKeysMode]$FunctionKeyMode = [TerminalFunctionKeysMode]::Default,        
    
        [ValidateSet(
            [ProxyMode]::Custom,
            [ProxyMode]::None
        )]
        [string]$ProxyMode = [ProxyMode]::None,
        [ValidateSet(
            [ProxyTunnelType]::Socks5,
            [ProxyTunnelType]::Socks4,
            [ProxyTunnelType]::Http
        )]
        [string]$ProxyType = [ProxyTunnelType]::Socks5,
        [string]$ProxyHost = '',
        [string]$ProxyHostPort = 0,
        [string]$ProxyUsername = '',
        [string]$ProxyPassword = '',
        [string]$ProxyLocalHostConnections = '',
        [string]$ProxyExcludedHosts = '',
        [TelnetTerminalDnsLookupType]$ProxyDNSLookupType = [TelnetTerminalDnsLookupType]::Automatic,
        [string]$ProxyTelnetCommand = '',
    
        [bool]$WarnIfAlreadyOpened = $false,
        [bool]$OpenCommentPrompt = $false,
        [bool]$OpenCommentIsRequired = $false,
        [bool]$TicketNumberIsRequiredOnOpen = $false,
        [bool]$CloseCommentPrompt = $false,
        [bool]$CloseCommentIsRequired = $false,
        [bool]$TicketNumberIsRequiredOnClose = $false,
        [bool]$CredentialViewedPrompt = $false,
        [bool]$CredentialViewedCommentIsRequired = $false,
        [bool]$TicketNumberIsRequiredOnCredentialViewed = $false,

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

            $res = New-DSEntryBase $SSHShell
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