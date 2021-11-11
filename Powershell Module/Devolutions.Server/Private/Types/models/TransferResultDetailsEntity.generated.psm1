using module '..\models\BaseResultEntity.generated.psm1'
using module '..\models\TransferEntryIdentifier.generated.psm1'

class TransferResultDetailsEntity
{
	[TransferEntryIdentifier]$Identifier = [TransferEntryIdentifier]::new()
	[BaseResultEntity]$Result = [BaseResultEntity]::new()
}
