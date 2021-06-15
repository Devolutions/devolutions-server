<#
    .SYNOPSIS
    Definition for 'Field' custom object
    .DESCRIPTION
    'Field' objects are used to add new unsupported (module-wise) fields to a DS object (RDP, SSH Shell...).
    .EXAMPLE
    [Field]$NewField1 = [Field]::new('NewlySupportedField1', 'ThisIsANewField1', 'root')
    [Field]$NewField2 = [Field]::new('NewlySupportedField2', 'ThisIsANewField2', 'data')
    [Field]$NewField3 = [Field]::new('NewlySupportedField3', 'ThisIsANewField3', 'events')
    .NOTES
    This is not meant to be used regularly. The point of this class is to add new fields to any object without updating the CMDlets in this module. For example,
    if we add a new field "X" in an RDPConfigured entry, you can add it with a new Field object even if we did not update the module yet.
#>

class Field {
    #New field's name
    [string]$Name
    #New field's value
    [string]$Value
    #New field's depth in object
    [ValidateSet('root', 'data', 'events')]
    [string]$Depth
    
    Field([string]$Name, [string]$Depth, [string]$Value) {
        $this.Name = $Name
        $this.Depth = $Depth
        $this.Value = $Value
    }
}