using module '..\models\PasswordGenerationEntity.generated.psm1'

class SpecifiedPasswordGenerationEntity : PasswordGenerationEntity 
{
	[int]$BracketsMin = 0
	[String]$CustomCharacters = ''
	[int]$CustomCharactersMin = 0
	[String]$CustomExcludeCharacters = ''
	[int]$DigitsMin = 0
	[int]$HighAnsiMin = 0
	[boolean]$IncludeBrackets = $false
	[boolean]$IncludeDigits = $true
	[boolean]$IncludeHighAnsi = $false
	[boolean]$IncludeLowerCase = $true
	[boolean]$IncludeMinus = $false
	[boolean]$IncludeSpace = $false
	[boolean]$IncludeSpecialChar = $false
	[boolean]$IncludeUnderline = $false
	[boolean]$IncludeUpperCase = $true
	[int]$Length = 8
	[int]$LowerCaseMin = 0
	[int]$MinusMin = 0
	[int]$SpaceMin = 0
	[int]$SpecialCharMin = 0
	[int]$UnderlineMin = 0
	[int]$UpperCaseMin = 0
	[boolean]$XmlCompliant = $false
}
