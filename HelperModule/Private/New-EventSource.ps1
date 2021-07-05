function New-EventSource {
    if ([System.Diagnostics.EventLog]::SourceExists('Devolutions Server Install Script') -eq $False) {
        New-EventLog -LogName 'Application' -Source 'Devolutions Server Install Script'
    }
}