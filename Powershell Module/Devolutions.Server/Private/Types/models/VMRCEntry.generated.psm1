using module '..\models\SensitiveItem.generated.psm1'
using module '..\enums\VMWareConsoleType.generated.psm1'
using module '..\models\VNCEntry.generated.psm1'

class VMRCEntry : VNCEntry 
{
	[boolean]$AuthPassthrough = $false
	[VMWareConsoleType]$ConsoleType = [VMWareConsoleType]::new()
	[boolean]$ForceUSLayout = $false
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[boolean]$PromptForVMName = $false
	[String]$ServerIP = ''
	[boolean]$ShowFullscreen = $false
	[String]$Username = ''
	[String]$VMId = ''
	[String]$VMName = ''
	[String]$VMPathAndFile = ''
}
