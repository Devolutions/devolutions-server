using namespace System
using namespace System.Diagnostics
function New-EventSource {
    if ([System.Diagnostics.EventLog]::SourceExists('Prerequisites Script') -eq $False) {
        New-EventLog -LogName 'Application' -Source 'Prerequisites Script'
    }
}