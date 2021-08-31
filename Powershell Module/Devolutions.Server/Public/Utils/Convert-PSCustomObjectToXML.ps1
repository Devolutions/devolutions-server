function Convert-PSCustomObjectToXML {
    [CmdletBinding()]
    param (
        $Object,
        $RootName = 'Connection'
    )
    process {
        [xml]$Doc = New-Object -TypeName System.Xml.XmlDocument
        $Doc.PreserveWhitespace = $true
        $Doc.AppendChild($doc.CreateXmlDeclaration('1.0', $null, $null)) | Out-Null
        $Root = $Doc.AppendChild($Doc.CreateElement($RootName))

        foreach ($Property in $Object.PSObject.Properties) {
            if (($Property.Value.Count -eq 1) -and ($Property.Value.GetType().Name -ne 'PSCustomObject')) {
                $Node = $Doc.CreateElement($Property.Name)
                $Node.InnerText = $Property.Value
                
                $Root.AppendChild($Node) | Out-Null
            }
            else {
                $Node = $Doc.CreateElement($Property.Name)
                $null = Recursive $Node $Property

                $Root.AppendChild($Node) | Out-Null
            }
        }

        return $Doc
    }
}

function Recursive {
    param(
        $Node,
        $Property
    )

    foreach ($NodeProperty in $Property.Value.PSObject.Properties) {
        $NewNode = $Doc.CreateElement($NodeProperty.Name)

        if ($NodeProperty.Value.GetType().Name -ne 'PSCustomObject') {
            $NewNode.InnerText = $NodeProperty.Value
            
            $Node.AppendChild($NewNode)
        }
        else {
            $null = Recursive $Node $NodePropert
        }
    }

    return $Node
}