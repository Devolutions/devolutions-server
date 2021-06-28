using namespace System.Management.Automation

class TerminalEncodingValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'UseFontEncoding', 'UTF_8', 'ISO_8859_1', 'ISO_8859_2', 'ISO_8859_3', 'ISO_8859_4', 'ISO_8859_5', 'ISO_8859_6', 'ISO_8859_7', 'ISO_8859_8', 'ISO_8859_9', 'ISO_8859_10', 'ISO_8859_11', 'ISO_8859_13', 'ISO_8859_14', 'ISO_8859_15', 'ISO_8859_16', 'KOI8_U', 'KOI8_R', 'HP_ROMAN8', 'VSCII', 'DEC_MCS', 'Win1250', 'Win1251', 'Win1252', 'Win1253', 'Win1254', 'Win1255', 'Win1256', 'Win1257', 'Win1258', 'CP437', 'CP620', 'CP819', 'CP852', 'CP878')
	}
}
