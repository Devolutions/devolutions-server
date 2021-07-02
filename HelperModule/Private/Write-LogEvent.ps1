function Write-LogEvent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Message,
        [Parameter()][switch]$Output,
        [Parameter()][switch]$LogIt,
        [EventLogEntryType]$logLevel = [EventLogEntryType]::Information
    )
    If ($Output) {
        Write-Output $Message
    } elseif ($LogIt) {
        Write-EventLog -LogName 'Application' -Source 'Prerequisites Script' -EntryType $logLevel -EventID 1 -Message $Message
    } else {
        Write-EventLog -LogName 'Application' -Source 'Prerequisites Script' -EntryType $logLevel -EventID 1 -Message $Message
        Write-Output $Message
    }
}