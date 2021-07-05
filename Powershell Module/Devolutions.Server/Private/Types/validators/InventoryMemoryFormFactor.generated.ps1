using namespace System.Management.Automation

class InventoryMemoryFormFactorValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Unknown', 'Other', 'SIP', 'DIP', 'ZIP', 'SOJ', 'Proprietary', 'SIMM', 'DIMM', 'TSOP', 'PGA', 'RIMM', 'SODIMM', 'SRIMM', 'SMD', 'SSMP', 'QFP', 'TQFP', 'SOIC', 'LCC', 'PLCC', 'BGA', 'FPBGA', 'LGA')
	}
}
