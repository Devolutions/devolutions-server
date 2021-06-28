using namespace System.Management.Automation

class InventoryMemoryTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Unknown', 'Other', 'DRAM', 'SynchronousDRAM', 'CacheDRAM', 'EDO', 'EDRAM', 'VRAM', 'SRAM', 'RAM', 'ROM', 'Flash', 'EEPROM', 'FEPROM', 'EPROM', 'CDRAM', 'ThreeDRAM', 'SDRAM', 'SGRAM', 'RDRAM', 'DDR', 'DDR2', 'DDR2FB_DIMM', 'DDR3', 'FBD2')
	}
}
