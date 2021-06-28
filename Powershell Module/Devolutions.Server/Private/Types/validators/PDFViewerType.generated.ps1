using namespace System.Management.Automation

class PDFViewerTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'AcrobatReader', 'PDFXViewer', 'PDFXViewerPro', 'EmbeddedFireFox', 'Native', 'Chrome', 'Edge')
	}
}
