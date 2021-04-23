function New-DSPassword {
    [CmdletBinding()]
    PARAM (
        [Devolutions.RemoteDesktopManager.PasswordGeneratorMode]$PasswordMode = [Devolutions.RemoteDesktopManager.PasswordGeneratorMode]::SpecifiedSettings,
        [Devolutions.RemoteDesktopManager.PronounceableCaseMode]$PronounceableCaseMode = [Devolutions.RemoteDesktopManager.PronounceableCaseMode]::MixedCase,
        [bool]$MorePronounceable = $false,

        [int]$Numerics = 1,
        [int]$Syllables = 1,
        [int]$Symbols = 1,
        [int]$Length = 8,
        
        [string]$Pattern = "",
        [bool]$PatternShuffleCharacters = $true,

        [string]$CustomExcludeCharacters = "",

        [bool]$XmlCompliant = $false,

        #[PasswordComplexity?]$Complexity

        [bool]$IncludeDigits = $true,
        [int]$DigitsMin = 0,

        [bool]$IncludeUpperCase = $true,
        [int]$UpperCaseMin = 0,

        [bool]$IncludeLowerCase = $true,
        [int]$LowerCaseMin = 0,

        [bool]$IncludeMinus = $false,
        [int]$MinusMin = 0,

        [bool]$IncludeUnderline = $false,
        [int]$UnderlineMin = 0,

        [bool]$IncludeSpace = $false,
        [int]$SpaceMin = 0,

        [bool]$IncludeSpecialChar = $false,
        [int]$SpecialCharMin = 0,

        [bool]$IncludeBrackets = $false,
        $BracketsMin = 0,

        [bool]$IncludeHighAnsi = $false,
        [int]$HighAnsiMin = 0,
        
        [string]$CustomCharacters = "",
        [int]$CustomCharactersMin = 0
    )
    
    BEGIN {

    }
    
    PROCESS {
        switch ($passwordMode) {
            "Default" { break; }
            "SpecifiedSettings" { 
                $URI = "$env:DS_URL/api/readable-passwords"

                $PasswordConfiguration = @{
                    Mode                    = $PasswordMode
                    #Complexity              = @{

                    #} | ConvertTo-Json
                    Length                  = $Length
                    IncludeUpperCase        = $IncludeUpperCase
                    UpperCaseMin            = $UpperCaseMin
                    IncludeLowerCase        = $IncludeLowerCase
                    LowerCaseMin            = $LowerCaseMin
                    IncludeDigits           = $IncludeDigits
                    DigitsMin               = $DigitsMin
                    IncludeMinus            = $IncludeMinus
                    MinusMin                = $MinusMin
                    IncludeUnderline        = $IncludeUnderline
                    UnderlineMin            = $UnderlineMin
                    IncludeSpace            = $IncludeSpace
                    Spacemin                = $SpaceMin
                    IncludeSpecialChar      = $IncludeSpecialChar
                    SpecialCharMin          = $SpecialCharMin
                    IncludeBrackets         = $IncludeBrackets
                    BracketsMin             = $BracketsMin
                    IncludeHighAnsi         = $IncludeHighAnsi
                    HighAnsiMin             = $HighAnsiMin
                    XmlCompliant            = $XmlCompliant
                    CustomCharacters        = $CustomCharacters
                    CustomCharactersMin     = $CustomCharactersMin
                    CustomExcludeCharacters = $CustomExcludeCharacters
                }

                break
            }
            "HumanReadable" { 
                $URI = "$env:DS_URL/api/readable-passwords"

                $PasswordConfiguration = @{
                    Mode      = $PasswordMode
                    Syllables = $Syllables
                    Numerics  = $Numerics
                    Symbols   = $Symbols
                }

                break
            }
            "Pattern" { 
                $URI = "$env:DS_URL/api/pattern-passwords"

                $PasswordConfiguration = @{
                    Mode                     = $PasswordMode
                    Pattern                  = $Pattern
                    PatternShuffleCharacters = $PatternShuffleCharacters
                } 

                break 
            }
            "Pronounceable" { 
                $URI = "$env:DS_URL/api/pronounceable-passwords"

                $PasswordConfiguration = @{
                    Mode                  = $PasswordMode
                    Length                = $Length
                    IncludeDigits         = $IncludeDigits
                    MorePronounceable     = $MorePronounceable
                    CustomCharacters      = $CustomCharacters
                    PronounceableCaseMode = $PronounceableCaseMode
                }

                break
            }
            "Strong" { 
                $URI = "$env:DS_URL/api/strong-passwords"

                $PasswordConfiguration = @{
                    Mode = $PasswordMode
                }

                break
            }
            Default {}
        }

        $RequestParams = @{
            URI    = $URI
            Method = "POST"
            Body   = $PasswordConfiguration | ConvertTo-Json
        }

        $res = Invoke-DS @RequestParams
        return $res
    }

    END {
        if ($res.isSuccess) {
            Write-Verbose "[New-DSPassword] Completed successfully!"
        }
        else {
            Write-Verbose "[New-DSPassword] Ended with errors..."
        }
    }
}