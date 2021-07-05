Function Convert-HexToBytes {
<#
.SYNOPSIS
.DESCRIPTION
.PARAMETER HexString
  string in Hex notation
.NOTES
  Version:        1.0
#>
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        [string]$HexString
    )
	
	BEGIN{
        Write-Verbose '[Convert-HexToBytes] begin...'
	}

	PROCESS {

	$Bytes = [byte[]]::new($HexString.Length / 2)

    For($i=0; $i -lt $HexString.Length; $i+=2){
        $Bytes[$i/2] = [convert]::ToByte($HexString.Substring($i, 2), 16)
    }
	
    return $Bytes
	}
	
		END{
        If ($?) {
          Write-Verbose '[Convert-HexToBytes] Completed Successfully.'
        } else {
	        Write-Verbose '[Convert-HexToBytes] ended with errors...'
		}
	}

}