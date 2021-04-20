function New-DSCredentialEventsSegment {
    [CmdletBinding()]
    param(
        [bool]$CredentialViewedCommentIsRequired,
        [bool]$CredentialViewedPrompt,
        [bool]$TicketNumberIsRequiredOnCredentialViewed
    )

    $EventsSegment = @{
        closeCommentIsRequired                   = $false
        closeCommentPrompt                       = $false
        credentialViewedCommentIsRequired        = $CredentialViewedCommentIsRequired
        credentialViewedPrompt                   = $CredentialViewedPrompt
        openCommentIsRequired                    = $false
        openCommentPrompt                        = $false
        openCommentPromptOnBrowserExtensionLink  = $false
        ticketNumberIsRequiredOnClose            = $false
        ticketNumberIsRequiredOnCredentialViewed = $TicketNumberIsRequiredOnCredentialViewed
        ticketNumberIsRequiredOnOpen             = $false
        warnIfAlreadyOpened                      = $false
    }

    return $EventsSegment
}
