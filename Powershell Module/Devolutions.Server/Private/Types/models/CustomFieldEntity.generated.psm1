using module '..\enums\CustomFieldType.generated.psm1'

class CustomFieldEntity
{
	[boolean]$CustomFieldHidden = $false
	[String]$CustomFieldTitle = ''
	[CustomFieldType]$CustomFieldType = [CustomFieldType]::new()
	[String]$CustomFieldValue = ''
}
