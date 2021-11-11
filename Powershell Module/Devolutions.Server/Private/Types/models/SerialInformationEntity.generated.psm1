using module '..\enums\DVLSEdition.generated.psm1'

class SerialInformationEntity
{
	[DVLSEdition]$Edition = [DVLSEdition]::new()
	[String]$Expiration = $null
	[boolean]$IsValidSerial = $false
	[int]$MaxUserCount = 0
}
