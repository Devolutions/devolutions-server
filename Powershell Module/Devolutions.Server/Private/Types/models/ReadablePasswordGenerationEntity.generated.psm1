using module '..\models\PasswordGenerationEntity.generated.psm1'

class ReadablePasswordGenerationEntity : PasswordGenerationEntity 
{
	[int]$NumNumerics = 1
	[int]$NumSyllables = 1
	[int]$NumSymbols = 1
}
