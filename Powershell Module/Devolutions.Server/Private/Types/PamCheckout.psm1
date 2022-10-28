class PamCheckout {
    [Nullable[guid]]$ID
    [Nullable[guid]]$UserID
    [string]$Username
    [Nullable[guid]]$CredentialID
    [string]$CredentialName
    [Nullable[guid]]$ApproverID
    [string]$ApproverName
    [string]$Reason
    [string]$ApproverMessage
    [string]$Status
    [Nullable[int]]$Duration
    [Nullable[datetime]]$RequestDateTime
    [Nullable[datetime]]$CheckoutDateTime
    [Nullable[datetime]]$CheckInDateTime
    [PSCustomObject]$ResolvedPermissions

    PamCheckout([PSCustomObject]$PamCheckout) {
        $this.ID = $PamCheckout.ID
        $this.UserID = $PamCheckout.UserID
        $this.Username = $PamCheckout.Username
        $this.CredentialID = $PamCheckout.CredentialID
        $this.CredentialName = $PamCheckout.CredentialName
        $this.ApproverID = $PamCheckout.ApproverID
        $this.ApproverName = $PamCheckout.ApproverName
        $this.Reason = $PamCheckout.Reason
        $this.ApproverMessage = $PamCheckout.ApproverMessage
        $this.Status = $PamCheckout.Status
        $this.Duration = $PamCheckout.Duration
        $this.RequestDateTime = $PamCheckout.RequestDateTime
        $this.CheckoutDateTime = $PamCheckout.CheckoutDateTime
        $this.CheckInDateTime = $PamCheckout.CheckInDateTime
        $this.ResolvedPermissions = $PamCheckout.ResolvedPermissions
    }

    PamCheckout() {
        $this.ID = [guid]::NewGuid()
        $this.UserID = [guid]::NewGuid()
        $this.Username = $null
        $this.CredentialID = [guid]::NewGuid()
        $this.CredentialName = $null
        $this.ApproverID = [guid]::NewGuid()
        $this.ApproverName = $null
        $this.Reason = $null
        $this.ApproverMessage = $null
        $this.Status = $null
        $this.Duration = $null
        $this.RequestDateTime = $null
        $this.CheckoutDateTime = $null
        $this.CheckInDateTime = $null
        $this.ResolvedPermissions = $null
    }
}