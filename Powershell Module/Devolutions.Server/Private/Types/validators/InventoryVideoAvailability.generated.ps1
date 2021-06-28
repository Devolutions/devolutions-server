using namespace System.Management.Automation

class InventoryVideoAvailabilityValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Other', 'Unknown', 'Running_FullPower', 'Warning', 'InTest', 'NotApplicable', 'PowerOff', 'OffLine', 'OffDuty', 'Degraded', 'NotInstalled', 'InstallError', 'PowerSave_Unknown', 'PowerSave_LowPowerMode', 'PowerSave_Standby', 'PowerCycle', 'PowerSave_Warning', 'Paused', 'NotReady', 'NotConfigured', 'Quiesced')
	}
}
