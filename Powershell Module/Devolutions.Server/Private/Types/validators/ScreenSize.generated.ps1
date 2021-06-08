using namespace System.Management.Automation

class ScreenSizeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'FullScreen', 'R640x480', 'R800x600', 'R1024x768', 'R1152x864', 'R1280x800', 'R1280x1024', 'R1440x900', 'R1400x1050', 'R1600x1024', 'R1600x1200', 'R1600x1280', 'R1680x1050', 'R1900x1200', 'R1920x1080', 'R1920x1200', 'R2048x1536', 'R2560x2048', 'R3200x2400', 'R3840x2400', 'Custom', 'CurrentScreenSize', 'CurrentWorkAreaSize')
	}
}
