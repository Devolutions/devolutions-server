using module '..\models\BaseSessionEntry.generated.psm1'
using module '..\enums\CmdParamDataType.generated.psm1'
using module '..\enums\CommandLineCaptureOutputMode.generated.psm1'
using module '..\enums\CommandLineExecutionMode.generated.psm1'
using module '..\enums\RunAsCredentialSource.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class CommandLineEntry : BaseSessionEntry 
{
	[String]$CaptureOutputFilePath = ''
	[CommandLineCaptureOutputMode]$CaptureOutputMode = [CommandLineCaptureOutputMode]::new()
	[String]$CommandLine = ''
	[boolean]$CommandLineWaitForApplicationToExit = $false
	[String]$Domain = ''
	[int]$EmbeddedWaitTime = 250
	[CommandLineExecutionMode]$ExecutionMode = [CommandLineExecutionMode]::new()
	[String]$Host = ''
	[boolean]$NetOnly = $false
	[CmdParamDataType]$Parameter1DataType = [CmdParamDataType]::new()
	[String]$Parameter1DefaultValue = ''
	[String]$Parameter1Label = 'Parameter #1'
	[CmdParamDataType]$Parameter2DataType = [CmdParamDataType]::new()
	[String]$Parameter2DefaultValue = ''
	[String]$Parameter2Label = 'Parameter #2'
	[CmdParamDataType]$Parameter3DataType = [CmdParamDataType]::new()
	[String]$Parameter3DefaultValue = ''
	[String]$Parameter3Label = 'Parameter #3'
	[CmdParamDataType]$Parameter4DataType = [CmdParamDataType]::new()
	[String]$Parameter4DefaultValue = ''
	[String]$Parameter4Label = 'Parameter #4'
	[CmdParamDataType]$Parameter5DataType = [CmdParamDataType]::new()
	[String]$Parameter5DefaultValue = ''
	[String]$Parameter5Label = 'Parameter #5'
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[String]$ProcessName = ''
	[boolean]$Run64BitsMode = $false
	[boolean]$RunAsAdministrator = $false
	[String]$RunAsCredentialConnectionId = ''
	[RunAsCredentialSource]$RunAsCredentialSource = [RunAsCredentialSource]::new()
	[String]$RunAsDomain = ''
	[SensitiveItem]$RunAsPasswordItem = [SensitiveItem]::new()
	[boolean]$RunAsPromptForCredentials = $false
	[String]$RunAsUsername = ''
	[boolean]$UseDefaultWorkingDirectory = $true
	[String]$Username = ''
	[boolean]$UseShellExecute = $true
	[String]$WorkingDirectory = ''
}
