using namespace System.Management.Automation

class InventoryVideoArchitectureValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Other', 'Unknown', 'CGA', 'EGA', 'VGA', 'SVGA', 'MDA', 'HGC', 'MCGA', '_8514A', 'XGA', 'LinearFrameBuffer', 'PC_98')
	}
}
