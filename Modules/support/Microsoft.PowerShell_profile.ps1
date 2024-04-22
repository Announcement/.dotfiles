Import-Module PSReadLine
Import-Module CompletionPredictor
Import-Module PSFzf

# Invoke-Command {
Set-PSReadLineKeyHandler -Chord 'Ctrl+l' -Function ShowParameterHelp
Set-PSReadLineKeyHandler -Chord 'Ctrl+k' -Function SelectCommandArgument
	
Set-Alias -Name j -Value Join-String
Set-Alias -Name cfj -Value ConvertFrom-Json
Set-Alias -Name ctj -Value ConvertTo-Json
Set-Alias -Name down -Value Write-WebRequest
	
Set-PSReadLineOption -PromptText "${script:Token} "

Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -PredictionSource Plugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -TerminateOrphanedConsoleApps

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
# }

# [System.Management.Automation.CommandInfo] | Get-Member | Where-Object { $_.Definition.GetType( }

# class ANSI
# {
# 	[string] $ESC = "$([char]0x1B)"
# 	[string] $CSI = "$([char]0x1B)["

# 	[char] $BEL = [char]0x07
# 	[char] $BS = [char]0x08
# 	[char] $HT = [char]0x09
# 	[char] $LF = [char]0x0A
# 	[char] $FF = [char]0x0C
# 	[char] $CR = [char]0x0D

# 	[hashtable] $Fe = [hashtable[string, char]]@{
# 		'ST' = [char]0x9C
# 	}

# 	[string] $ST = ([char]0x1B) + [char]0x5C

# 	static [string] CUU($n = 1)
# 	{
# 		return "$([char]0x1B)[${n}A"
# 	}
# 	static [string] CUD($n = 1)
# 	{
# 		return "$([char]0x1B)[${n}B"
# 	}
# 	static [string] CUF($n = 1)
# 	{
# 		return "$([char]0x1B)[${n}C"
# 	}
# 	static [string] CUB($n = 1)
# 	{
# 		return "$([char]0x1B)[${n}D"
# 	}
# 	static [string] CNL($n = 1)
# 	{
# 		return "$([char]0x1B)[${n}E"
# 	}
# 	static [string] CPL($n = 1)
# 	{
# 		return "$([char]0x1B)[${n}F"
# 	}
# 	static [string] CHA($n = 1)
# 	{
# 		return "$([char]0x1B)[${n}G"
# 	}
# 	static [string] CUP($n = 1, $m = 1)
# 	{
# 		return "$([char]0x1B)[$n;${m}H"
# 	}
# 	static [string] ED([int]$n = 0)
# 	{
# 		return "$([char]0x1B)[${n}J"
# 	}
# 	static [string] EL([int]$n = 0)
# 	{
# 		return "$([char]0x1B)[${n}K"
# 	}
# 	static [string] SU([int]$n = 1)
# 	{
# 		return "$([char]0x1B)[${n}S"
# 	}
# 	static [string] SD([int]$n = 1)
# 	{
# 		return "$([char]0x1B)[${n}T"
# 	}
# 	static [string] HVP($n = 1, $m = 1)
# 	{
# 		return "$([char]0x1B)[$n;${m}f"
# 	}
# 	static [string] SGR([int]$n)
# 	{
# 		return "$([char]0x1B)[${n}m"
# 	}
# 	static [string] DSR()
# 	{
# 		return "$([char]0x1B)[6n"
# 	}

# 	static [string] OSC ([string]$seq)
# 	{
# 		return ANSI.ESC + ']' + $seq + ANSI.BE
# 	}
# }

# # if (Get-Module PSFzf) {
# # }

# # $ANSI = @{}
# # $ANSI.C0 = [hashtable]@{
# #     BEL = [char]0x07
# #     BS = [char]0x08
# #     HT = [char]0x09
# #     LF = [char]0x0A
# #     FF = [char]0x0C
# #     CR = [char]0x0D
# #     ESC = [char]0x1B
# # }

# # $ANSI.ESC = $ANSI.C0.ESC

# # $ANSI.C1 = [hashtable]@{
# #     SS2 =  	@([char]0x8E, "$($ANSI.C0.ESC)N") ;
# #     SS3 =  	@([char]0x8F, "$($ANSI.C0.ESC)O") ;
# #     DCS =  	@([char]0x90, "$($ANSI.C0.ESC)P") ;
# #     CSI =  	@([char]0x9B, "$($ANSI.C0.ESC)[") ;
# #     ST =  	@([char]0x9C, "$($ANSI.C0.ESC)\") ;
# #     OSC =  	@([char]0x9D, "$($ANSI.C0.ESC)]") ;
# #     SOS =  	@([char]0x98, "$($ANSI.C0.ESC)X") ;
# #     PM =  	@([char]0x9E, "$($ANSI.C0.ESC)^") ;
# #     APC =  	@([char]0x9F, "$($ANSI.C0.ESC)_") ;
# # }

# # $ANSI.CSI = "$($ANSI.ESC)["
# # $using:ANSI
# # function ANSI:CUU {
# #   [CmdletBinding()]
# #   param(
# #     [parameter(ValueFromPipeline)]$n
# #   )

# #   process {
# #     "$($ANSI.CSI)$($n)A"
# #   }
# # }

# # $global:ESC = [ANSI]::ESC

# # $global:CSI = "$ESC$([char]0x5B)"

# function script:Initialize-Profile {
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
	param($wordToComplete, $commandAst, $cursorPosition)
	dotnet complete --position $cursorPosition "$commandAst" | ForEach-Object {
		[System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
	}
}
# }

function Global:__Terminal-Get-LastExitCode
{
	if ($? -eq $True)
	{
		return 0
	}
	$LastHistoryEntry = $(Get-History -Count 1)
	$IsPowerShellError = $Error[0].InvocationInfo.HistoryId -eq $LastHistoryEntry.Id
	if ($IsPowerShellError)
	{
		return -1
	}
	return $LastExitCode
}

Set-Variable -Scope Local -Name Token -Value '→'
function Lprompt
{
	return $Token
}
function Rprompt
{
	return ($PWD.ProviderPath -Replace '\\', '/') -Replace ($HOME -Replace '\\', '/'), '~'
}

$global:prompts = @((Get-Item function:Lprompt), (Get-Item function:Rprompt))

function prompt
{
	
	# First, emit a mark for the _end_ of the previous command.
  
	$gle = $(__Terminal-Get-LastExitCode)
	$LastHistoryEntry = $(Get-History -Count 1)
	# Skip finishing the command if the first command has not yet started
	if ($Global:__LastHistoryId -ne -1)
	{
		if ($LastHistoryEntry.Id -eq $Global:__LastHistoryId)
		{
			# Don't provide a command line or exit code if there was no history entry (eg. ctrl+c, enter on no command)
			$out += "`e]133;D`a"
		}
		else
		{
			$out += "`e]133;D;$gle`a"
		}
	}
  
  
	$loc = $($executionContext.SessionState.Path.CurrentLocation)
  
	# Prompt started
	$out += "`e]133;A$([char]07)"
  
	# CWD
	$out += "`e]9;9;`"$loc`"$([char]07)"
  
	# (your prompt here)
	$out += Lprompt
	$out += ' '
  
	# Prompt ended, Command started
	$out += "`e]133;B$([char]07)"
  
	$Global:__LastHistoryId = $LastHistoryEntry.Id
	
	# "[2;1R" | Set-Variable -Name ""

	$window_width = $host.UI.RawUI.WindowSize.Width
	$right_prompt = Rprompt
# return "$([char]0x1B)[${n}G"
	Write-Host -NoNewline "$([char]0x1B)7$([char]0x1B)[$($window_width - $right_prompt.Length)G$right_prompt$([char]0x1B)8"
	return $out
}

# script:Initialize-Profile()

# function script:prompt {

# }

# function script:interactive {

# }


# Import-Module CompletionPredictor

# $global:Token = '→'

# # Register-EngineEvent -SourceIdentifier PromptDebug -Action{
# #   Write-Debug -Message "{0}" -f $event.messagedata
# # }

# function prompt {
#   [CmdletBinding()]
#     param (
#       $param0
#     )
#   begin {
#     # write-debug "begin"
#     # New-Event -SourceIdentifier PromptDebug -MessageData $args
#     Write-Debug $args
#   }

#   process {
#     Write-Host -NoNewline -ForegroundColor White $global:Token
#   }

#   end {
#     return " "
#   }
# }

# # PSConsoleHostReadLin

# # $Global:__LastHistoryId = -1

# # function Global:__Terminal-Get-LastExitCode {
# #   if ($? -eq $True) {
# #     return 0
# #   }
# #   $LastHistoryEntry = $(Get-History -Count 1)
# #   $IsPowerShellError = $Error[0].InvocationInfo.HistoryId -eq $LastHistoryEntry.Id
# #   if ($IsPowerShellError) {
# #     return -1
# #   }
# #   return $LastExitCode
# # }

# # OSC 133 ; A ST ("FTCS_PROMPT") - The start of a prompt.
# # OSC 133 ; B ST ("FTCS_COMMAND_START") - The start of a commandline (READ: the end of the prompt).
# # OSC 133 ; C ST ("FTCS_COMMAND_EXECUTED") - The start of the command output / the end of the commandline.
# # OSC 133 ; D ; <ExitCode> ST ("FTCS_COMMAND_FINISHED") - the end of a command. ExitCode If ExitCode is provided, then the Terminal will treat 0 as "success" and anything else as an error. If omitted, the terminal will just leave the mark the default color.

# # function prompt {
# #   $private:ESC = "$([char]0x1b)"
# #   # $private:BEL = "$([char]0x7)"
# #   $private:OSC = "$ESC]"
# #   $private:ST = "$ESC\"

# #   # $profiled = $PSScriptRoot | Split-Path -Parent
# #   # $global:DEBUG_FILE = "$PSScriptRoot\debug.txt"

# #   # Out-File -LiteralPath $global:DEBUG_FILE -InputObject (Get-History) -Append

# #   $private:FTCS_PROMPT = "$($OSC)133;A$($ST)"
# #   $private:FTCS_COMMAND_START = "$($OSC)133;B$($ST)"
# #   # $private:FTCS_COMMAND_EXECUTED = "$($OSC)133;C$($ST)"
# #   # $private:FTCS_COMMAND_FINISHED = "$($OSC)133;$($EXITCODE)D$($ST)"

# # # $cursor = $Host.UI.RawUI.CursorPosition;
# # # $window = $Host.UI.RawUI.WindowSize;

# # # (Get-Host).UI.RawUI.SetBufferContents(
# # #   [System.Management.Automation.Host.Rectangle]@{ Left = $window.Width - 5; Top = $cursor.Y; Right = $window.Width; Bottom = $cursor.y },
# # #   (New-Object System.Management.Automation.Host.BufferCell -ArgumentList @("t", [System.ConsoleColor]::Black, [System.ConsoleColor]::Blue, 1))
# # # );






# # # $cur = $null;
# # # $line = $null;

# # # [Microsot.PowerShell.PSReadLine]::get
# # Write-Host -NoNewline $private:FTCS_PROMPT
# # Write-Host -NoNewline $global:Token
# # Write-Host -NoNewline $private:FTCS_COMMAND_START

# # " "

# #   # First, emit a mark for the _end_ of the previous command.

# #   # $gle = $(__Terminal-Get-LastExitCode);
# #   # $LastHistoryEntry = $(Get-History -Count 1)
# #   # # Skip finishing the command if the first command has not yet started
# #   # if ($Global:__LastHistoryId -ne -1) {
# #   #   if ($LastHistoryEntry.Id -eq $Global:__LastHistoryId) {
# #   #     # Don't provide a command line or exit code if there was no history entry (eg. ctrl+c, enter on no command)
# #   #     $out += "$()]133;D`a"
# #   #   } else {
# #   #     $out += "`e]133;D;$gle`a"
# #   #   }
# #   # }


# #   # $loc = $($executionContext.SessionState.Path.CurrentLocation);

# #   # # Prompt started
# #   # $out += "`e]133;A$([char]07)";

# #   # # CWD
# #   # $out += "`e]9;9;`"$loc`"$([char]07)";

# #   # # (your prompt here)
# #   # $out += "$Token ";

# #   # # Prompt ended, Command started
# #   # $out += "`e]133;B$([char]07)";

# #   # $Global:__LastHistoryId = $LastHistoryEntry.Id

# #   # return $out
# # }
# # Import-Module 'C:\Users\power\Documents\GitHub\vcpkg\scripts\posh-vcpkg'
# # Import-Module 'C:\Users\power\Documents\PowerShell\_rg.ps1'
# # Import-Module PSReadLine
# # Import-Module PSFzf

# # Import-Module 'C:\Users\power\Documents\PowerShell\Modules\Catpuccin\Catppuccin.psm1'
# # Import-Module 'C:\Users\power\vcpkg\scripts\posh-vcpkg'

# # Get-Module -ListAvailable -All | Group-Object -Property Name | Sort-Object -Property Count | Where-Object Count -GT 1 | ForEach-Object { Write-Host -ForegroundColor blue $_.Name; $sorted = $_.Group | Sort-Object version $latest = $($sorted | Select-Object -Last 1).Version; $previous = $($sorted | Where-Object Version -LT $latest | Select-Object -Last 1).Version; $legacy = $($sorted | Where-Object Version -LT $latest | Select-Object -First 1).Version; $_.Group | Where-Object Version -LT $latest | Remove-Module | Tee-Object -Variable Removed ; Uninstall-PSResource -Name $_.Name -Version "[$($legacy.Version), $($previous.Version)]" }

# $host.ui.RawUI.WindowTitle = "PowerShell $($PSVersionTable.PSVersion)"

# # Import-Module 'C:\Users\power\vcpkg\scripts\posh-vc⍺⍺⊂pkg'

# #34de4b3d-13a8-4540-b76d-b9e8d3851756 PowerToys CommandNotFound module
# #34de4b3d-13a8-4540-b76d-b9e8d3851756

# Invoke-Command {
#   # $private:keyboardSuggestions = 'Ctrl+t'
#   # $private:keyboardHistory = 'Ctrl+r'
#   # $private:commandOverride = [ScriptBlock] { param($Location) Write-Host $Location }
#   # $private:commandHandler = [ScriptBlock] { Invoke-FzfTabCompletion - }

#   # Set-PsFzfOption -PSReadlineChordProvider $keyboardSuggestions -PSReadlineChordReverseHistory $keyboardHistory
#   # Set-PsFzfOption -AltCCommand $commandOverride
#   # Set-PsFzfOption -TabExpansion

#   Set-PSReadLineOption -ShowToolTips
#   Set-PSReadLineOption -PredictionSource Plugin
#   Set-PSReadLineOption -PredictionViewStyle ListView
#   Set-PSReadLineOption -PromptText $global:Token
#   # Set-PSReadLineKeyHandler -Key Tab -ScriptBlock $commandHandler
#   Set-PSReadLineKeyHandler -Chord 'Ctrl+Spacebar' -Function MenuComplete

#   # "Started at '$(Get-Location)' with $(Get-Module | Measure-Object | Select-Object -ExpandProperty Count) loaded modules." | Out-Default


# }

# # function Send-Completions {
# #   $commandLine = ""
# #   $cursorIndex = 0
# #   [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$commandLine, [ref]$cursorIndex)
# #   $completionPrefix = $commandLine

# #   $result = "`e]633;Completions"
# #   if ($completionPrefix.Length -gt 0) {
# #     $completions = TabExpansion2 -inputScript $completionPrefix -cursorColumn $cursorIndex
# #     if ($null -ne $completions.CompletionMatches) {
# #       $result += ";$($completions.ReplacementIndex);$($completions.ReplacementLength);$($cursorIndex);"
# #       $result += $completions.CompletionMatches | ConvertTo-Json -Compress
# #     }
# #   }
# #   $result += "`a"

# #   Write-Host -NoNewLine $result
# # }

# # function Set-MappedKeyHandlers {
#   # Terminal suggest - always on keybindings
#   # Set-PSReadLineKeyHandler -Chord 'F12,b' -ScriptBlock {
#   #   Send-Completions
#   # }


# # }

# # Register key handlers if PSReadLine is available
# # if (Get-Module -Name PSReadLine) {
#   # Set-MappedKeyHandlers
# # }
# # else {
# #   Write-Host "PsReadline was disabled. Shell Completion was not enabled."
# # }


#   process {

#   }

#   end {

#   }
# }
# filter ConvertTo-DirectoryTree {
#     $currentLocation = $_
#     $referenceList = [System.Collections.Stack]@()

#     while
#     ($currentLocation.FullName -ne $referenceObject.Root.FullName)
#     {
#         $referenceList.Add($currentLocation.FullName) | Out-Null
#         $currentLocation = $currentLocation.Parent
#     }

#     $heirarchy = [System.Collections.Hashtable]@{}
	
#     $heirarchy[([Stack]$referenceList)];
	
#     Out-Default -InputObject $referenceList
# }
# function global:New-Tree {
#     [CmdletBinding()]
#     param (
#         [Parameter(ValueFromPipeline)]
#         [System.IO.DirectoryInfo]
#         $destination = (Get-Location | Get-Item)
#     )
#     process {
#         $currentLocation = $referenceObject
#         $referenceList = [System.Collections.ArrayList]@($currentLocation.FullName)

#         while ($currentLocation.FullName -ne $referenceObject.Root.FullName) {
#             $referenceList.Add($currentLocation.FullName)
#             $currentLocation = $currentLocation.Parent
#         }

#         $referenceList
#     }
# }
function global:Get-DirectoryTree
{
	[CmdletBinding()]
	param(
		[Parameter(Position = 0)]
		[System.IO.DirectoryInfo]
		$referenceObject = (Get-Location | Get-Item),

		[Parameter(ValueFromPipeline)]
		[System.IO.DirectoryInfo]
		$inputObject = ($HOME)
	)
	#   dynamicparam {<statement list>}
	begin
	{
		$currentLocation = $referenceObject
		$referenceList = [System.Collections.ArrayList]@($currentLocation.FullName)

		while ($currentLocation.FullName -ne $referenceObject.Root.FullName)
		{
			$referenceList.Add($currentLocation.FullName)
			$currentLocation = $currentLocation.Parent
		}

		$referenceList
	}
	process
	{
		$currentLocation = $inputObject
		$inputList = [System.Collections.ArrayList]@($inputObject.FullName)

		while ($currentLocation.FullName -ne $inputObject.Root.FullName)
		{
			$inputList.Add($currentLocation.FullName)
			$currentLocation = $currentLocation.Parent
		}
		# $_ | Out-Default
		# foreach ($item in $input) {
		#     $item | Out-Default
		# }
		# $inputObject | Out-Default
		# Write-Debug "$_"
		# Write-Debug "$inputObject -> $referenceObject"
		# Write-Debug $input
		# $currentLocation = $inputObject;


		# while ($currentLocation.FullName -ne $currentLocation.Root.FullName -and $tree -notcontains $currentLocation.FullName)
		# { # -and $tree.Contains($currentLocation.FullName) -eq $false) {
		#     $tree.Add($currentLocation.FullName)
		#     $currentLocation = $currentLocation.Parent
		# }

		# $currentLocation.FullName
	}
	end
	{
		# $tree
		# $tree.join(";")
	}
	clean
	{
		# Remove-Variable -Scope Local -Name tree
	}
}
