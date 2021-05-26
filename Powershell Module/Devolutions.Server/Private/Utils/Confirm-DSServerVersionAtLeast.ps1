function Confirm-DSServerVersionAtLeast {
    <#
    .DESCRIPTION
    Validate if the current DVLS version is above specified version.
    .OUTPUTS
    If server version is equal to or above the defined version -> $True
    If server version is lower than the defined version -> $False
    #>
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [System.Version]$CandidVersion
    )

    return ($Global:DSInstanceVersion -as [System.Version]).CompareTo($CandidVersion) -ge 0
}