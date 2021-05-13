class NewParam {
    [string]$Name
    [ValidateSet('root', 'data', 'events')]
    [string]$Level
    [string]$Value

    NewParam($Name, $Level, $Value) {
        $this.Name = $Name
        $this.Level = $Level
        $this.Value = $Value
    }
}