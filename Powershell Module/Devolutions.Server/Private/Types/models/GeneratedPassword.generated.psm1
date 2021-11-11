using module '..\enums\PasswordQualityEstimator.generated.psm1'

class GeneratedPassword
{
	[String]$Password = ''
	[String]$Phonetic = ''
	[PasswordQualityEstimator]$Strength = [PasswordQualityEstimator]::new()
}
