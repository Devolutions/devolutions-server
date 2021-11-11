using module '..\models\DataEntryOtherValueItem.generated.psm1'

class DataEntryOther
{
	[DataEntryOtherValueItem]$OtherValues = [DataEntryOtherValueItem]::new()
	[String]$Url = ''
}
