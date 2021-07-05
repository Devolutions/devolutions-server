using Namespace System
using Namespace System.Diagnostics

Function Write-LogEvent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Message,
        [Parameter()][switch]$Output,
        [Parameter()][switch]$LogIt,
        [Parameter()][switch]$Errors,
        [EventLogEntryType]$logInfo = [EventLogEntryType]::Information,
        [EventLogEntryType]$logError = [EventLogEntryType]::Error
    )
    If ($Output) {
        Write-Output $Message 
    } elseif ($LogIt) {
        Write-EventLog -LogName 'Application' -Source 'Devolutions Server Install Script' -EntryType $logInfo -EventID 1 -Message $Message
    } elseif ($Errors) {
        Write-EventLog -LogName 'Application' -Source 'Devolutions Server Install Script' -EntryType $logError -EventID 1 -Message $Message
        Write-Output $Message
    } elseif ($Errors -and $LogIt) {
        Write-EventLog -LogName 'Application' -Source 'Devolutions Server Install Script' -EntryType $logError -EventID 1 -Message $Message
    } else {
        Write-EventLog -LogName 'Application' -Source 'Devolutions Server Install Script' -EntryType $logInfo -EventID 1 -Message $Message
        Write-Output $Message
    }
}