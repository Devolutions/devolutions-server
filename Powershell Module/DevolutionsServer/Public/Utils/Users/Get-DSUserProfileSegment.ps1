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
        [string]$countryName,
        [string]$department,
        [string]$fax,
        [string]$firstName,
        [string]$gravatarEmail,
        [string]$jobTitle,
        [string]$lastName,
        [string]$phone,
        [string]$state,
        [string]$workphone
    )
    PROCESS {
        try {
            $profileData = @{
                gravatarUrl           = ""
                fullName              = ""
                address               = if ($address) { $address } else { "" }
                cellPhone             = if ($cellPhone) { $cellPhone } else { "" }
                companyName           = if ($companyName) { $companyName } else { "" }
                countryCode           = ""
                countryName           = if ($countryName) { $countryName } else { "" }
                culture               = ""
                department            = if ($department) { $department } else { "" }
                fax                   = if ($fax) { $fax } else { "" }
                firstName             = if ($firstName) { $firstName } else { "" }
                gravatarEmail         = if ($gravatarEmail) { $gravatarEmail } else { "" }
                jobTitle              = if ($jobTitle) { $jobTitle } else { "" }
                lastName              = if ($lastName) { $lastName } else { "" }
                phone                 = if ($phone) { $phone } else { "" }
                serial                = ""
                state                 = if ($state) { $state } else { "" }
                subscribeToNewsLetter = $false
                workphone             = if ($workphone) { $workphone } else { "" }

            }
        
            return ($profileData)
        }
        catch {
            throw $_.Exception
        }
        
    }
}