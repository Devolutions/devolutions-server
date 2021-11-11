using module '..\models\RemotePort.generated.psm1'

class RemoteNetworkAdapter
{
	[RemotePort]$Ports = [RemotePort]::new()
	[String]$DatabasePath = ''
	[String]$Description = ''
	[boolean]$DHCPEnabled = $false
	[string[]]$IPAddress = $null
	[String]$IPAddressMac = $null
	[boolean]$IPEnabled = $false
	[string[]]$IPSubnet = $null
	[boolean]$IsAdapter = $false
	[String]$MACAddress = ''
	[String]$Name = ''
}
