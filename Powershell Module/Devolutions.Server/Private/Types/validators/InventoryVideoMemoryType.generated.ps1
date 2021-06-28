using namespace System.Management.Automation

class InventoryVideoMemoryTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Other', 'Unknown', 'VRAM', 'DRAM', 'SRAM', 'WRAM', 'EDORAM', 'BurstSynchronousDRAM', 'PipelinedBurstSRAM', 'CDRAM', 'ThreeDRAM', 'SDRAM', 'SGRAM')
	}
}
