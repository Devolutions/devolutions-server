using module '..\enums\PasswordComplexityValidation.generated.psm1'

class PasswordComplexity
{
	[String]$ID = ''
	[int]$Length = 0
	[int]$MinimumLengthCount = 0
	[int]$MinimumLowerCaseCount = 0
	[int]$MinimumNumericCount = 0
	[int]$MinimumSymbolCount = 0
	[int]$MinimumUpperCaseCount = 0
	[String]$Name = ''
	[PasswordComplexityValidation]$Validation = [PasswordComplexityValidation]::new()
}
