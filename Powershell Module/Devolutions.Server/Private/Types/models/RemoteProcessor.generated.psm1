
class RemoteProcessor
{
	[int]$AddressWidth = 0
	[int]$Architecture = 0
	[int]$CpuStatus = 0
	[int]$CurrentClockSpeed = 0
	[String]$CurrentClockSpeedMac = ''
	[int]$CurrentVoltage = 0
	[String]$Description = ''
	[int]$ExtClock = 0
	[boolean]$HyperThreadingEnabled = $false
	[int]$L2CacheSize = 0
	[String]$L2CacheSizeMac = ''
	[int]$L2CacheSpeed = 0
	[int]$L3CacheSize = 0
	[String]$L3CacheSizeMac = ''
	[int]$L3CacheSpeed = 0
	[String]$Manufacturer = ''
	[int]$MaxClockSpeed = 0
	[String]$Name = ''
	[int]$NumberOfCores = 0
	[int]$NumberOfLogicalProcessors = 0
	[String]$SocketDesignation = ''
}
