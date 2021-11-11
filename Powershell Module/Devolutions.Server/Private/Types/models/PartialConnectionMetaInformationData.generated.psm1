using module '..\models\ConnectionMetaInformation.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class PartialConnectionMetaInformationData
{
	[ConnectionMetaInformation]$MetaInformation = [ConnectionMetaInformation]::new()
	[SensitiveItem]$ContactPasswordItem = [SensitiveItem]::new()
}
