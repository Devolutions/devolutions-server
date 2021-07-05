function Confirm-Prompt {
    param (
        [parameter(Mandatory)][string]$functionName,
        [parameter(Mandatory)][string]$functionCMD,
        [parameter(Mandatory)][string]$message
    )
    $title = $functionName
    $question = $message

    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 0) {
        Write-LogEvent "$env:USERNAME confirmed installation."
        $functionCMD
    } else {
        Write-LogEvent "$env:USERNAME cancelled installation."
        return
    }
}