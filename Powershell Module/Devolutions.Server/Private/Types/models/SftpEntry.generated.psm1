using module '..\models\FtpNativeEntry.generated.psm1'
using module '..\models\SSHGateway.generated.psm1'

class SftpEntry : FtpNativeEntry 
{
	[int]$Port = 22
	[boolean]$ShowHiddenFiles = $false
	[boolean]$UseSSHGateway = $false
	[SSHGateway]$SSHGateways = [SSHGateway]::new()
}
