Import-Module PSReadLine
Import-Module PSFzf
Import-Module CompletionPredictor

$PSStyle.FileInfo.Directory = "`e[38;2;255;255;255m"

$keyboardSuggestions = 'Ctrl+t'
$keyboardHistory = 'Ctrl+r'

$commandOverride = [ScriptBlock]{ param($Location) Write-Host $Location }
$commandHandler = [ScriptBlock]{ Invoke-FzfTabCompletion - }

Set-PsFzfOption -PSReadlineChordProvider $keyboardSuggestions -PSReadlineChordReverseHistory $keyboardHistory
Set-PsFzfOption -AltCCommand $commandOverride
Set-PsFzfOption -TabExpansion

Set-PSReadLineOption -ShowToolTips

Set-PSReadLineOption -PredictionSource HistoryAndPlugin

Set-PSReadLineKeyHandler -Key Tab -ScriptBlock $commandHandler


$host.ui.RawUI.WindowTitle = "PowerShell $($PSVersionTable.PSVersion)"

deno completions powershell | Out-String | Invoke-Expression
# caddy completion powershell | Out-String | Invoke-Expression


# Import-Module PSReadLine

# Import-Module PoshColor
Set-Variable -Scope Script -Name Token -Value "→"
# if (Get-Command)
# Test-Path -Path $PROFILE
# Write-Host -ForegroundColor Cyan "Francis"

# Import-Module PSReadLine

# Clear-Host

# Start-Job { aria2c --enable-rpc --rpc-listen-all } -Name ARIA2

function prompt {
    # "→ "
    # "● "
    # $(if ($NestedPromptLevel -ge 1) { '○' }) + '● '
    # "⊘ "
    # "⊷"
    # "→ "
    # Get-Variable -Name PromptToken -Scope Prompt
    Write-Host -NoNewline $Token

    " "
}


# ≣≡≸⊳⋮`
# Vertical Ellipsis

# U+22EF

# ⋯⋮⋱
# Down Right Diagonal Ellipsis
# U+22F2

# ⊶
# ⊷⊸
# ⊙⊸. "C:\rakubrew\bin\rakubrew.exe" init PowerShell | Out-String | Invoke-Expression
# (& pixi completion --shell powershell) | Out-String | Invoke-Expression
