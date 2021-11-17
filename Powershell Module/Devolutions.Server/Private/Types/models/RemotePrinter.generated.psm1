
class RemotePrinter
{
	[int]$Attributes = 0
	[int]$Availability = 0
	[int]$AveragePagesPerMinute = 0
	[String]$Caption = ''
	[String]$Comment = ''
	[int]$ConfigManagerErrorCode = 0
	[String]$ConfigManagerUserConfig = ''
	[String]$CreationClassName = ''
	[String]$CurrentCharSet = ''
	[int]$CurrentLanguage = 0
	[String]$CurrentMimeType = ''
	[String]$CurrentNaturalLanguage = ''
	[String]$CurrentPaperType = ''
	[boolean]$Default = $false
	[int]$DefaultCopies = 0
	[int]$DefaultLanguage = 0
	[String]$DefaultMimeType = ''
	[int]$DefaultNumberUp = 0
	[String]$DefaultPaperType = ''
	[int]$DefaultPriority = 0
	[String]$Description = ''
	[int]$DetectedErrorState = 0
	[String]$DeviceID = ''
	[boolean]$Direct = $false
	[boolean]$DoCompleteFirst = $true
	[String]$DriverName = ''
	[boolean]$EnableBIDI = $false
	[boolean]$EnableDevQueryPrint = $false
	[String]$ErrorCleared = ''
	[String]$ErrorDescription = ''
	[int]$ExtendedDetectedErrorState = 0
	[int]$ExtendedPrinterStatus = 0
	[boolean]$Hidden = $false
	[int]$HorizontalResolution = 0
	[String]$InstallDate = $null
	[int]$JobCountSinceLastReset = 0
	[boolean]$KeepPrintedJobs = $false
	[int]$LastErrorCode = 0
	[boolean]$Local = $false
	[String]$Location = ''
	[int]$MarkingTechnology = 0
	[int]$MaxCopies = 0
	[int]$MaxNumberUp = 0
	[String]$Name = ''
	[boolean]$Network = $false
	[String]$Parameters = ''
	[String]$PNPDeviceID = ''
	[String]$PortName = ''
	[String]$PowerManagementSupported = ''
	[int]$PrinterState = 0
	[int]$PrinterStatus = 0
	[String]$PrintJobDataType = ''
	[String]$PrintProcessor = ''
	[int]$Priority = 0
	[boolean]$Published = $false
	[boolean]$Queued = $false
	[boolean]$RawOnly = $false
	[String]$SeparatorFile = ''
	[String]$ServerName = ''
	[boolean]$Shared = $false
	[String]$ShareName = ''
	[boolean]$SpoolEnabled = $true
	[String]$StartTime = $null
	[String]$Status = ''
	[String]$StatusInfo = ''
	[String]$SystemCreationClassName = ''
	[String]$SystemName = ''
	[String]$TimeOfLastReset = $null
	[String]$UntilTime = $null
	[int]$VerticalResolution = 0
	[boolean]$WorkOffline = $false
}