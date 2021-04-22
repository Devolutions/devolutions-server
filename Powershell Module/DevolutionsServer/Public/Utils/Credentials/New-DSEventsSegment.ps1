function New-DSCredentialEventsSegment {
    [CmdletBinding()]
    param(
        [hashtable]$ParamList
    )

    $EventsSegment = @{
        closeCommentIsRequired                   = $false
        closeCommentPrompt                       = $false
        credentialViewedCommentIsRequired        = $ParamList.CredentialViewedCommentIsRequired
        credentialViewedPrompt                   = $ParamList.CredentialViewedPrompt
        openCommentIsRequired                    = $false
        openCommentPrompt                        = $false
        openCommentPromptOnBrowserExtensionLink  = $false
        ticketNumberIsRequiredOnClose            = $false
        TicketNumberIsRequiredOnCredentialViewed = $ParamList.TicketNumberIsRequiredOnCredentialViewed
        ticketNumberIsRequiredOnOpen             = $false
        warnIfAlreadyOpened                      = $false
    }

    return $EventsSegment
}
