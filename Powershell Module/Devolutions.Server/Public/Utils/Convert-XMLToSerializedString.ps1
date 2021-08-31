function Convert-XMLToSerializedString {
    [CmdletBinding()]
    param (
        [System.Xml.XmlDocument]$xml
    )
    
    process {
        $stringBuilder = New-Object System.Text.StringBuilder
        $xmlSettings = New-Object System.Xml.XmlWriterSettings

        $xmlSettings.Indent = $true

        $xmlWriter = [System.Xml.XmlWriter]::Create($stringBuilder, $xmlSettings)

        try {
            $xml.WriteContentTo($xmlWriter)
        }
        catch {
            Write-Error $_.ErrorDetails
        }
        
        $xmlWriter.Flush()
        $xmlWriter.Close()
        return $stringBuilder.ToString()
    }
}