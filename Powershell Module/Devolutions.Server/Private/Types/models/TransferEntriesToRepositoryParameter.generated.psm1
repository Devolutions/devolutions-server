using module '..\models\TransferEntryIdentifier.generated.psm1'

class TransferEntriesToRepositoryParameter
{
	[TransferEntryIdentifier]$Entries = [TransferEntryIdentifier]::new()
	[String]$RepositoryID = $null
}
