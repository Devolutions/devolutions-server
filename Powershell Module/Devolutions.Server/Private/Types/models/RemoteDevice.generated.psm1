using module '..\models\RemoteKeyboard.generated.psm1'
using module '..\models\RemotePointingDevice.generated.psm1'
using module '..\models\RemoteSimpleDevice.generated.psm1'

class RemoteDevice
{
	[RemoteKeyboard]$Keyboards = [RemoteKeyboard]::new()
	[RemotePointingDevice]$PointingDevices = [RemotePointingDevice]::new()
	[RemoteSimpleDevice]$SimpleDevice = [RemoteSimpleDevice]::new()
}
