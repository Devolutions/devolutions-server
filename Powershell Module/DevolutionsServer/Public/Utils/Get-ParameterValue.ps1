function Get-ParameterValues {
    <#
        .Synopsis
            Get the actual values of parameters which have manually set (non-null) default values or values passed in the call
        .Description
            Unlike $PSBoundParameters, the hashtable returned from Get-ParameterValues includes non-empty default parameter values.
            NOTE: Default values that are the same as the implied values are ignored (e.g.: empty strings, zero numbers, nulls).
        .Link
            https://gist.github.com/Jaykul/72f30dce2cca55e8cd73e97670db0b09/
        .Link
            https://gist.github.com/elovelan/d697882b99d24f1b637c7e7a97f721f2/
        .Example
            function Test-Parameters {
                [CmdletBinding()]
                param(
                    $Name = $Env:UserName,
                    $Age
                )
                $Parameters = Get-ParameterValues
                # This WILL ALWAYS have a value... 
                Write-Host $Parameters["Name"]
                # But this will NOT always have a value... 
                Write-Host $PSBoundParameters["Name"]
            }
    #>
    [CmdletBinding()]
    param()
    # The $MyInvocation for the caller
    $Invocation = Get-Variable -Scope 1 -Name MyInvocation -ValueOnly
    # The $PSBoundParameters for the caller
    $BoundParameters = Get-Variable -Scope 1 -Name PSBoundParameters -ValueOnly
    
    $ParameterValues = @{}
    foreach($parameter in $Invocation.MyCommand.Parameters.GetEnumerator()) {
        # gm -in $parameter.Value | Out-Default
        try {
            $key = $parameter.Key
            if($null -ne ($value = Get-Variable -Name $key -ValueOnly -ErrorAction Ignore)) {
                if(($value -ne ($null -as $parameter.Value.ParameterType)) -or $parameter.Value.ParameterType -eq [System.Boolean]) {
                    $ParameterValues[$key] = $value
                }
            }
            if($BoundParameters.ContainsKey($key)) {
                $ParameterValues[$key] = $BoundParameters[$key]
            }
        } finally {}
    }
    $ParameterValues
  }