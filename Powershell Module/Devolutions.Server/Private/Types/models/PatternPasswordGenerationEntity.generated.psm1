using module '..\models\PasswordGenerationEntity.generated.psm1'

class PatternPasswordGenerationEntity : PasswordGenerationEntity 
{
	[String]$Pattern = ''
	[boolean]$PatternShuffleCharacters = $true
}
