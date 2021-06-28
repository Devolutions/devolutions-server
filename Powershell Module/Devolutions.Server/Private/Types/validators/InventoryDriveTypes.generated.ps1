using namespace System.Management.Automation

class InventoryDriveTypesValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Unknown', 'NoRootDirectory', 'RemovableDisk', 'LocalDisk', 'NetworkDrive', 'CompactDisc', 'RAMDisk')
	}
}
