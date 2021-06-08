using namespace System.Management.Automation

class EmailAuthenticationTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('AppleToken', 'HTTPMD5Digest', 'MD5ChallengeResponse', 'NTLM', 'Password')
	}
}
