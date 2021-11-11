using module '..\models\QueryArguments.generated.psm1'

class AttachmentQueryArguments : QueryArguments 
{
	[boolean]$Private = $false
	[boolean]$UseSensitiveMode = $false
}
