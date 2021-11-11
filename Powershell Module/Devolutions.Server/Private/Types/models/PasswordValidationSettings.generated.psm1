using module '..\models\PasswordComplexity.generated.psm1'
using module '..\enums\PasswordComplexityUsage.generated.psm1'
using module '..\enums\PasswordPwnedUsage.generated.psm1'

class PasswordValidationSettings
{
	[String]$GroupMain = ''
	[boolean]$IsPrivateEntry = $false
	[String]$Password = ''
	[PasswordComplexity]$PasswordComplexity = [PasswordComplexity]::new()
	[PasswordComplexityUsage]$PasswordComplexityUsage = [PasswordComplexityUsage]::new()
	[PasswordPwnedUsage]$PasswordPwnedUsage = [PasswordPwnedUsage]::new()
	[String]$PasswordTemplateID = ''
	[String]$RepositoryId = $null
}
