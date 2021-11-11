using module '..\enums\PasswordGeneratorMode.generated.psm1'

class PasswordGenerationEntity
{
	[int]$PreviewPasswordCount = 30
	[PasswordGeneratorMode]$PasswordGeneratorMode = [PasswordGeneratorMode]::new()
}
