function Convert-XMLToPSCustomObject {
    [CmdletBinding()]
    param (
        $XML
    )

    process {
        $Return = New-Object -TypeName PSCustomObject

        $XML | Get-Member -MemberType Property | ForEach-Object {
            if ($_.Definition -Match '^\bstring\b.*$') {
                $Return | Add-Member -MemberType NoteProperty -Name ($_.Name) -Value ($XML.($_.Name))
            }
            elseif ($_.Definition -Match '^\System.Xml.XmlElement\b.*$') {
                $Return | Add-Member -MemberType NoteProperty -Name ($_.Name) -Value (Convert-XMLToPSCustomObject -XML ($XML.($_.Name)))
            }
        }

        $Return
    }
}