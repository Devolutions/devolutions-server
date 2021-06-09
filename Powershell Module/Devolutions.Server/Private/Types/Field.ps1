class Field {
    [string]$Name
    [string]$Value
    [ValidateSet('root', 'data', 'events')]
    [string]$Depth
    
    Field([string]$Name, [string]$Depth, [string]$Value) {
        $this.Name = $Name
        $this.Depth = $Depth
        $this.Value = $Value
    }
}