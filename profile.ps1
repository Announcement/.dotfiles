$token = "→"

# $preloadedModules = Get-Module

# foreach ($moduleName in @('PSReadLine', 'PSFzf', 'CompletionPredictor', 'Az.Tools.Predictor')) {
#     # if (-not (Get-Module $moduleName) -and (Get-InstalledModule $moduleName)) {
#       Import-Module $moduleName
#     # }
# }

# if (Get-Module PSReadLine) {
  Set-PSReadLineOption -ShowToolTips
  Set-PSReadLineOption -PredictionSource Plugin
  Set-PSReadLineOption -PredictionViewStyle ListView
  Set-PSReadLineOption -TerminateOrphanedConsoleApps

  Set-PSReadLineKeyHandler -Chord 'Ctrl+Spacebar' -Function MenuComplete

  Set-PSReadLineOption -PromptText "$token "

  Set-PSReadLineOption -ContinuationPrompt "  "
# }

# if (Get-Module PSFzf) {
        # Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
# }

Import-Module CompletionPredictor
# Import-Module Az.Tools.Predictor

Set-Alias -Name j -Value Join-String
Set-Alias -Name cfj -Value ConvertFrom-Json
Set-Alias -Name ctj -Value ConvertTo-Json
Set-Alias -Name down -Value Write-WebRequest

function prompt {
  Write-Host -NoNewline "${TOKEN}"

  " "
}