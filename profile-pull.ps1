
if (Get-Module PSFzf) {
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
        # Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
        # Set-PsFzfOption -TabExpansion
}



Set-Alias -Name j -Value Join-String
Set-Alias -Name cfj -Value ConvertFrom-Json
Set-Alias -Name ctj -Value ConvertTo-Json
Set-Alias -Name down -Value Write-WebRequest

# $ESC = [char]0x1B
# $CSI = [char]0x9B
# $ST = [char]0x9C
# $OSC = [char]0x9D
# $BEL = [char]0x07

# Set-PSReadLineKeyHandler -Chord Enter -ScriptBlock {
#   [Microsoft.PowerShell.PSConsoleReadLine]::MoveToEndOfLine()
#   Write-Host -NoNewline "`e]133;C`u{7}"
#   [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
# }
function prompt {
  # OSC 133 ; A ST ("FTCS_PROMPT") - The start of a prompt.
  # OSC 133 ; B ST ("FTCS_COMMAND_START") - The start of a commandline (READ: the end of the prompt).
  # OSC 133 ; C ST ("FTCS_COMMAND_EXECUTED") - The start of the command output / the end of the commandline.
  # OSC 133 ; D ; <ExitCode> ST ("FTCS_COMMAND_FINISHED") - the end of a command. ExitCode If ExitCode is provided, then the Terminal will treat 0 as "success" and anything else as an error. If omitted, the terminal will just leave the mark the default color.
  # if ($global:initialized) {
  #   Write-Host -NoNewline "`e]133;D;$($? ? 0 : ((Get-History -Count 1).Id -EQ ($Error[0].InvocationInfo.HistoryID)) ? -1 : $LASTEXITCODE)`u{7}"
  # }
  # Write-Host -NoNewline "`e]133;A`u{7}"
  Write-Host -NoNewline "${TOKEN}"
  # Write-Host -NoNewLine "`e]133;B`u{7}"
  # $global:initialized=$true
  " "
}
# # >>> xmake >>>
# if (Test-Path -Path "C:\Users\power\xmake\scripts\profile-win.ps1" -PathType Leaf) {
#     . "C:\Users\power\xmake\scripts\profile-win.ps1"
# }
# # <<< xmake <<<

