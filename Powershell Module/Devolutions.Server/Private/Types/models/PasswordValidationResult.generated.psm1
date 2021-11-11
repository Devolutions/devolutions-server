using module '..\enums\PasswordComplexityValidation.generated.psm1'
using module '..\enums\PasswordPwnedUsage.generated.psm1'

class PasswordValidationResult
{
	[boolean]$CheckPasswordPwned = $false
	[String]$Details = ''
	[PasswordComplexityValidation]$PasswordComplexityValidation = [PasswordComplexityValidation]::new()
	[PasswordPwnedUsage]$PasswordPwnedUsage = [PasswordPwnedUsage]::new()
}
