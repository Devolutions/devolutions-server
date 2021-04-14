function Get-DSCredentialEventsSegment {
    [CmdletBinding()]
    param(
        [bool]$credentialViewedCommentIsRequired,
        [bool]$credentialViewedPrompt,
        [bool]$ticketNumberIsRequiredOnCredentialViewed
    )

    $EventsSegment = @{
        closeCommentIsRequired                   = $false
        closeCommentPrompt                       = $false
        credentialViewedCommentIsRequired        = $credentialViewedCommentIsRequired
        credentialViewedPrompt                   = $credentialViewedPrompt
        openCommentIsRequired                    = $false
        openCommentPrompt                        = $false
        openCommentPromptOnBrowserExtensionLink  = $false
        ticketNumberIsRequiredOnClose            = $false
        ticketNumberIsRequiredOnCredentialViewed = $ticketNumberIsRequiredOnCredentialViewed
        ticketNumberIsRequiredOnOpen             = $false
        warnIfAlreadyOpened                      = $false
    }

    return $EventsSegment
}
