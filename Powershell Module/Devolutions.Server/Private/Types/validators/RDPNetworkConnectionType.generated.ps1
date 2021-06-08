using namespace System.Management.Automation

class RDPNetworkConnectionTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Modem', 'LowSpeedBroadband', 'Satellite', 'HighSpeedBroadband', 'WAN', 'LAN')
	}
}
