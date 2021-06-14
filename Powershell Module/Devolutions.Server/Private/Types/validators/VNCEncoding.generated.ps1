using namespace System.Management.Automation

class VNCEncodingValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Auto', 'CoRRE', 'Hextile', 'Raw', 'RRE', 'Tight', 'Ultra', 'Zlib', 'ZlibHEX', 'ZlibHalftone', 'Zlib16Gray', 'ZlibThousands', 'Zrle', 'Adaptive')
	}
}
