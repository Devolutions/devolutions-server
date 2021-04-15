function New-DSCredentialEntry {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
    [CmdletBinding()]
    param(
        #Base credential data
        [ValidateNotNullOrEmpty()]
        [string]$EntryName,
        [ValidateNotNullOrEmpty()]
        [string]$Username,
        [string]$Password,
        [string]$UserDomain,
        [guid]$VaultId = [guid]::Empty,
        [string]$Folder,
        [string]$Description,
        [string]$Tags,

        #Events
        [bool]$credentialViewedCommentIsRequired,
        [bool]$credentialViewedPrompt,
        [bool]$ticketNumberIsRequiredOnCredentialViewed,

        #Security
        [ValidateSet('Default', 'Not available', 'Automatic', 'Manual', 'Inherited', 'Optional')]
        [string]$checkOutMode
    )
        
    BEGIN {
        Write-Verbose '[New-DSCredentialEntry] begin...'

        $URI = "$Script:DSBaseURI/api/connections/partial/save"
    
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            #Get vault context. Result=1 -> Vault exists. Result=2 -> Vault not found
            $VaultCtx = Set-DSVaultsContext $VaultId

            if ($VaultCtx.Body.result -ne [Devolutions.RemoteDesktopManager.SaveResult]::Success) { 
                throw [System.Management.Automation.ItemNotFoundException]::new("Vault could not be found. Please make sure you provide a valid vault ID.") 
            }  

            #Get credential segment
            $CredSegmentData = @{
                Username   = $Username
                Password   = $Password
                UserDomain = $UserDomain
            }
            $CredSegment = New-DSCredentialSegment @CredSegmentData

            #Get events (log) segment
            $EventsSegmentData = @{
                credentialViewedCommentIsRequired        = $credentialViewedCommentIsRequired
                credentialViewedPrompt                   = $credentialViewedPrompt
                ticketNumberIsRequiredOnCredentialViewed = $ticketNumberIsRequiredOnCredentialViewed
            }
            $EventsSegment = Get-DSCredentialEventsSegment @EventsSegmentData

            #Prepare entry data for encryption
            $EntryData = $CredSegment + @{
                group          = $Folder
                connectionType = 26
                repositoryID   = $VaultId
                name           = $EntryName
            }
    
            #Encrypt entry data
            $EncryptedData = Protect-ResourceToHexString ($EntryData | ConvertTo-Json)
    
            #Prepare credential body for POST request
            $CredentialBody = @{
                checkOutMode   = [Devolutions.RemoteDesktopManager.CheckOutMode]::$checkOutMode.value__
                group          = $Folder
                connectionType = 26
                data           = $EncryptedData
                repositoryId   = $VaultId
                name           = $EntryName
                events         = $EventsSegment
                description    = $Description
                keywords       = $Tags
            }
                
            $params = @{
                Uri    = $URI
                Method = 'POST'
                Body   = $CredentialBody | ConvertTo-Json
            }
    
            $res = Invoke-DS @params
            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }

    END {
        if ($? -and $res.isSuccess) {
            Write-Verbose '[New-DSCredentialEntry] Completed successfully.'
        }
        else {
            Write-Verbose '[New-DSCredentialEntry] Ended with errors...'
        }
    }
}