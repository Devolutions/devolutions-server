using namespace System.Management.Automation

class GeoIPModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'FreeGeoIP', 'MaxMind')
	}
}
