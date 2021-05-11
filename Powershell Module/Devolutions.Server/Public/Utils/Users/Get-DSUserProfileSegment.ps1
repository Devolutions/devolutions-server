function Get-DSUserProfileSegment {
    <#
        .SYNOPSIS
        Returns a segment containing user profile infos required for creating a new user.
    #>
    [CmdletBinding()]
    PARAM(
        [PSCustomObject]$ParamList
    )
    PROCESS {
        try {
            $ProfileSegment = @{
                Address               = $ParamList.Address
                CellPhone             = $ParamList.Mobile
                CompanyName           = $ParamList.CompanyName
                CountryCode           = ""
                CountryName           = $ParamList.Country
                CreationDate          = ""
                Culture               = ""
                Department            = $ParamList.Department
                Fax                   = $ParamList.Fax
                FirstName             = $ParamList.FirstName
                FullName              = if (![string]::IsNullOrEmpty($ParamList.FirstName) -and ![string]::IsNullOrEmpty($ParamList.LastName)) {
                    "$($ParamList.FirstName) $($ParamList.LastName)"
                }
                elseif ([string]::IsNullOrEmpty($ParamList.FirstName) -and ![string]::IsNullOrEmpty($ParamList.LastName)) {
                    "$($ParamList.FirstName)"
                }
                elseif (![string]::IsNullOrEmpty($ParamList.FirstName) -and [string]::IsNullOrEmpty($ParamList.LastName)) {
                    "$($ParamList.LastName)"
                }
                else {
                    ""
                }
                GravatarEmail         = $ParamList.GravatarEmail
                GravatarUrl           = ""
                #ID
                JobTitle              = $ParamList.JobTitle
                LastName              = $ParamList.LastName
                Phone                 = $ParamList.Phone
                Serial                = ""
                State                 = ""
                SubscribeToNewsletter = $false
                #UserID
                Workphone             = $ParamList.Workphone
            }
            
            return $ProfileSegment
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
}