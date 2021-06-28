using namespace System.Management.Automation

class ApplicationSourceValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'RDM', 'PVM', 'Web', 'Agent', 'ChromeRDMExtension', 'FireFoxRDMExtension', 'IERDMExtension', 'SafariRDMExtension', 'ChromePVMExtension', 'FireFoxPVMExtension', 'IEPVMExtension', 'SafariPVMExtension', 'DPSConsole', 'WebLogin', 'Scripting', 'Powershell', 'Launcher', 'Cli', 'HubImporter', 'RecordingServer')
	}
}
