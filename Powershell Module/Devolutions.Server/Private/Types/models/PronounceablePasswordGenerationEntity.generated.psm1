using module '..\models\PasswordGenerationEntity.generated.psm1'
using module '..\enums\PronounceableCaseMode.generated.psm1'

class PronounceablePasswordGenerationEntity : PasswordGenerationEntity 
{
	[String]$CustomCharacters = ''
	[boolean]$IncludeDigits = $true
	[int]$Length = 8
	[boolean]$MorePronounceable = $false
	[PronounceableCaseMode]$PronounceableCaseMode = [PronounceableCaseMode]::new()
}
