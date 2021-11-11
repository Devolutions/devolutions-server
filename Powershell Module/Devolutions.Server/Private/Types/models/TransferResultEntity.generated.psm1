using module '..\models\BaseResultEntity.generated.psm1'
using module '..\models\TransferResultDetailsEntity.generated.psm1'

class TransferResultEntity : BaseResultEntity 
{
	[TransferResultDetailsEntity]$Details = [TransferResultDetailsEntity]::new()
}
