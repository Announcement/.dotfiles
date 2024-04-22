function Send-Completions {
    $commandLine = ""
    $cursorIndex = 0
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$commandLine, [ref]$cursorIndex)
    $completionPrefix = $commandLine
  
    $result = "`e]633;Completions"
    if ($completionPrefix.Length -gt 0) {
      $completions = TabExpansion2 -inputScript $completionPrefix -cursorColumn $cursorIndex
      if ($null -ne $completions.CompletionMatches) {
        $result += ";$($completions.ReplacementIndex);$($completions.ReplacementLength);$($cursorIndex);"
        $result += $completions.CompletionMatches | ConvertTo-Json -Compress
      }
    }
    $result += "`a"
  
    Write-Host -NoNewLine $result
  }
  
  function Set-MappedKeyHandlers {
    # Terminal suggest - always on keybindings
    Set-PSReadLineKeyHandler -Chord 'F12,b' -ScriptBlock {
      Send-Completions
    }
  }
  
  # Register key handlers if PSReadLine is available
  if (Get-Module -Name PSReadLine) {
    Set-MappedKeyHandlers
  }
  else {
    Write-Host "PsReadline was disabled. Shell Completion was not enabled."
  }