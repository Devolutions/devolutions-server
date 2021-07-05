using namespace System.Management.Automation

class InventoryHardwareTypesValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Unkwnown', 'CDRom', 'Keyboard', 'PointingDevice', 'SimpleDevice')
	}
}
