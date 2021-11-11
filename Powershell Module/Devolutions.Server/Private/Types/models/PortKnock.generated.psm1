using module '..\enums\PortKnockProtocolType.generated.psm1'

class PortKnock
{
	[int]$Port = 0
	[PortKnockProtocolType]$ProtocolType = [PortKnockProtocolType]::new()
	[int]$SortPriority = 0
}
