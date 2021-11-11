using module '..\enums\PortForwardMode.generated.psm1'

class PortForward
{
	[String]$Destination = ''
	[int]$DestinationPort = 0
	[String]$ID = ''
	[PortForwardMode]$Mode = [PortForwardMode]::new()
	[String]$Source = ''
	[String]$Description = ''
	[int]$SourcePort = 0
}
