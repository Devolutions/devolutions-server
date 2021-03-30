function Get-DSUserProfileSegment {
    <#
    .SYNOPSIS
        Returns a segment containing user profile infos required for creating a new user.
    #>
    [CmdletBinding()]
    param(
        [string]$address,
        [string]$cellPhone,
        [string]$companyName,
        [string]$countryCode,
        [string]$countryName,
        [string]$creationDate,
        [string]$culture,
        [string]$department,
        [string]$fax,
        [string]$firstName,
        [string]$fullName,
        [string]$gravatarEmail,
        [string]$gravatarUrl,
        [string]$jobTitle,
        [string]$lastName,
        [string]$phone,
        [string]$serial,
        [string]$state,
        [bool]$subscribeToNewsletter,
        [string]$userID,
        [string]$workphone
    )
    PROCESS {
        try {
            $profileData = @{
                address               = if ($address) { $address } else { "" }
                cellPhone             = if ($cellPhone) { $cellPhone } else { "" }
                companyName           = if ($companyName) { $companyName } else { "" }
                countryCode           = if ($countryCode) { $countryCode } else { "" }
                countryName           = if ($countryName) { $countryName } else { "" }
                creationDate          = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffK")
                culture               = if ($culture) { $culture } else { "en-US" }
                department            = if ($department) { $department } else { "" }
                fax                   = if ($fax) { $fax } else { "" }
                firstName             = if ($firstName) { $firstName } else { "" }
                fullName              = if ($firstName -and !$lastName) { $firstName } elseif (!$firstName -and $lastName) { $lastName } elseif ($firstName -and $lastName) { "$firstName $lastName" } else { $fullName = "" }
                gravatarEmail         = if ($gravatarEmail) { $gravatarEmail } else { "" }
                gravatarUrl           = if ($gravatarUrl) { $gravatarUrl } else { "" }
                jobTitle              = if ($jobTitle) { $jobTitle } else { "" }
                lastName              = if ($lastName) { $lastName } else { "" }
                phone                 = if ($phone) { $phone } else { "" }
                serial                = if ($serial) { $serial } else { "" }
                state                 = if ($state) { $state } else { "" }
                subscribeToNewsletter = $subscribeToNewsletter
                userID                = [guid]::NewGuid()
                workphone             = if ($workphone) { $workphone } else { "" }
            }
        
            return ($profileData)
        }
        catch {
            throw $_.Exception
        }
        
    }
}