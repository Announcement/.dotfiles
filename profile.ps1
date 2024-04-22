Import-Module -Global PsReadline
Import-Module -Global PSFzf

# Import-Module -Name "$env:USERPROFILE/Documents/Powershell/Scripts/windows-terminal.ps1"

if (Get-Module -Name PSReadLine) {
  Set-PSReadLineOption -ShowToolTips
  Set-PSReadLineOption -PredictionSource Plugin
  Set-PSReadLineOption -PredictionViewStyle ListView
  Set-PSReadLineOption -TerminateOrphanedConsoleApps

  Set-PSReadLineKeyHandler -Chord 'Ctrl+Spacebar' -Function MenuComplete

  # Set-PSReadLineOption -PromptText '$token '

  if (Get-Module -Name PSFzf) {
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
  }
}

$token = "→"

# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
# Set-PsFzfOption -TabExpansion

Set-Alias -Name j -Value Join-String
Set-Alias -Name cfj -Value ConvertFrom-Json
Set-Alias -Name ctj -Value ConvertTo-Json
Set-Alias -Name down -Value Write-WebRequest

function prompt {
  Write-Host -NoNewline $token

  " "
}