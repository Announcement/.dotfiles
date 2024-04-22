# ug --help | Out-String -Stream | % { $expression = [regex]::new("(?<=^\x20{4})(?=\S)-.+([\r\n]+)", [System.Text.RegularExpressions.RegexOptions]::Multiline); $expression.Match($_) ; $expression.Matches() }
enum PSEditions {
	Core
	Desktop
}
enum Privelege {
	System
	User
}
# $Locations = [pscustomobject]@{
# 	Program = $env:ProgramFiles
# 	User = $env:USERPROFILE
# 	Public = $env:PUBLIC
# 	All = $env:ALLUSERSPROFILE
# 	Common = $env:CommonProgramFiles
# 	Local = $env:LOCALAPPDATA
# 	AppData = $env:APPDATA
# }

<#

#>

filter Expand-Path {
	$PSItem |
	ForEach-Object Split([System.IO.Path]::PathSeparator) |
	ForEach-Object { param($path = $_) [System.Environment]::ExpandEnvironmentVariables($path) } |
	Where-Object { param($path = $_) $path | Test-Path } |
	Resolve-Path |
	Get-Item |
	ForEach-Object FullName |
	Remove-Duplicates
}
function Resolve-Powershell {
	[CmdletBinding(PositionalBinding)]
	param (
		# Explicit Edition
		[Parameter(ParameterSetName = "ExplicitEditionUser", Mandatory, Position = 0)]
		[Parameter(ParameterSetName = "ExplicitEditionSystem", Mandatory, Position = 0)]
		[Parameter(ParameterSetName = "ImplicitPrivelege", Mandatory, Position = 0)]
		[Parameter(ParameterSetName = "ExplicitTrait", Position = 0)]
		[PSEditions]$Edition,

		[Parameter(ParameterSetName = "ExplicitTrait", Mandatory, Position = 1)]
		# [ValidateSet('Intrinsic', 'Inherit', 'Explicit')]
		[System.EnvironmentVariableTarget]$Trait,

		[Parameter(ParameterSetName = "ImplicitPrivelege")]
		[Privelege]$Privelege,

		[Parameter(Mandatory, ParameterSetName = "CoreIncluded")]
		[Parameter(Mandatory, ParameterSetName = "CoreSystem")]
		[Parameter(Mandatory, ParameterSetName = "CoreUser")]
		[switch]$Core,

		[Parameter(Mandatory, ParameterSetName = "DesktopIncluded")]
		[Parameter(Mandatory, ParameterSetName = "DesktopSystem")]
		[Parameter(Mandatory, ParameterSetName = "DesktopUser")]
		[switch]$Desktop,
		
		[Parameter(Mandatory, ParameterSetName = "CoreIncluded")]
		[Parameter(Mandatory, ParameterSetName = "DesktopIncluded")]
		[switch]$Included,

		[Parameter(Mandatory, ParameterSetName = "ExplicitEditionSystem")]
		[Parameter(Mandatory, ParameterSetName = "CoreSystem")]
		[Parameter(Mandatory, ParameterSetName = "DesktopSystem")]
		[switch]$System,
		
		[Parameter(Mandatory, ParameterSetName = "ExplicitEditionUser")]
		[Parameter(Mandatory, ParameterSetName = "CoreUser")]
		[Parameter(Mandatory, ParameterSetName = "DesktopUser")]
		[switch]$User
	)
	$Current = -not ($Core -or $Desktop)
	$Bundled = -not ($User -or $Installed)

	if ($Current -and $Bundled) { return $PSHOME }
	if ($Current -and $Installed) {}
	if ($Current -and $User) { return $PROFILE.CurrentUserAllHosts | Split-Path }
	if ($Core -and $Bundled) {}
	if ($Core -and $Installed) {}
	if ($Core -and $User) {}
	if ($Desktop -and $Bundled) {}
	if ($Desktop -and $Installed) {}
	if ($Desktop -and $User) {}

	# if ($Current) {
	# 	if ($Bundled) {
	# 		return $PSHOME
	# 	}
	# 	if ($User) {}
	# }

	# $programPrefix
	# $userPrefix = "$HOME\Documents"
	
	# if ($Core) {
	# 	if (-not $User -and -not $Installed) {
	# 		return "$env:ProgramFiles\PowerShell\7"
	# 	}
	# 	if ($User) {}
	# }
	# if ($Desktop) {
	# 	if (-not $User -and -not $Installed) {
	# 		return "$env:WINDIR\system32\WindowsPowerShell\v1.0"
	# 	}
	# 	if ($User) {}
	# }
	
	# if ($PSCmdlet.ParameterSetName.)
}

# $CORE = 'PowerShell'
# $powershellCoreInstallation = Join-Path $env:ProgramFiles
# $DESKTOP = 'WindowsPowerShell'
# $powershellDesktopInstallation = Join-Path $env:ProgramFiles
# $powershellCoreConfiguration = Join-Path $env:USERPROFILE PowerShell
# $powershellDesktopConfiguration = Join-Path $env:USERPROFILE WindowsPowerShell


# $installationPowershellLatest = Join-Path $powershellInstallation 7
# $installationPowershellPreview = Join-Path $powershellInstallation 7-preview

# PowerShell modules
# $env:WINDIR\system32\WindowsPowerShell\v1.0\Modules
# $env:ProgramFiles\PowerShell\7\Modules

# User installed
# AllUsers scope
# $env:ProgramFiles\WindowsPowerShell\Modules
# $env:ProgramFiles\PowerShell\Modules

# $HOME\Documents\WindowsPowerShell\Modules
# $HOME\Documents\PowerShell\Modules
# $powershellGeneric = Join-Path $powershellInstallation


# powershellModules = [PSCustomObject]@{
# 	'7' = (Join-Path $env:ProgramFiles PowerShell 7 Modules)
# 	'preview' = (Join-Path $env:ProgramFiles PowerShell 7-preview Modules)
# 	'all' = (Join-Path $env:ProgramFiles PowerShell Modules)
# 	'windows' = (Join-Path $env:ProgramFiles WindowsPowerShell Modules)
# 	'user' = (Join-Path (Split-Path $PROFILE.CurrentUserAllHosts) Modules)
# }



function New-Program {
	[CmdletBinding(PositionalBinding, DefaultParameterSetName = "Machine")]
	param (
		[Parameter(ParameterSetName = "Machine", Position = 0)]
		[Parameter(ParameterSetName = "User", Position = 0)]
		[string]$installationName,
        
		[Parameter(ParameterSetName = "Machine")]
		[switch]$x86,
        
		[Parameter(ParameterSetName = "User")]
		[switch]$user,

		[version]$currentVersion
	)
	switch ($PSCmdlet.ParameterSetName) {
		'Machine' {
			return [pscustomobject]@{
				Configuration = (Join-Path $env:ProgramData $installationName)
				Installation  = (Join-Path ($x86 ? ${env:ProgramFiles(x86)} : $env:ProgramFiles ) $installationName)
				Powershell    = (Join-Path (Split-Path $PROFILE.AllUsersCurrentHost) Modules $installationName "$installationName.psd1")
			}
			break
		}
		'User' {
			return [pscustomobject]@{
				Configuration = (Join-Path $env:APPDATA $installationName)
				Installation  = (Join-Path $Env:LOCALAPPDATA $installationName)
				Powershell    = (Join-Path (Split-Path $PROFILE) Modules $installationName "$installationName.psd1")
			}
			break
		}
	}
}

function Sync-Module {
	[CmdletBinding(PositionalBinding)]
	[OutputType([System.Void])]
	param(
		[Parameter(Mandatory,
			ValueFromPipeline,
			ValueFromPipelineByPropertyName,
			Position = 0)]
		[ValidateNotNullOrEmpty()]
		[SupportsWildCards()]
		[string[]]
		$Name
	)
	Process {
		Remove-Module $Name
		Import-Module $Name
	}
}

function Add-Path {
	[CmdletBinding()]
	param (
		# Specifies a path to one or more locations. Wildcards are permitted.
		[Parameter(Mandatory = $true,
			Position = 0,
			ParameterSetName = "ResolvablePaths",
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments,
			HelpMessage = "Path to one or more locations.")]
		[ValidateNotNullOrEmpty()]
		[SupportsWildcards()]
		[string[]]
		$Path
	)
	
	$currentPath = [System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::Process) | Expand-Path
	$previousPath = $Path | Expand-Path

	$environmentPaths = ($currentPath + $previousPath) | Remove-Duplicates
	$environmentPath = $environmentPaths | Join-String -Separator ([System.IO.Path]::PathSeparator)

	[System.Environment]::SetEnvironmentVariable('PATH', $environmentPath, [System.EnvironmentVariableTarget]::Process) | Out-Null
}

function Get-DataSize {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true,
			Position = 0,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments = $true)]
		[Int64]
		$size
	)
	($size -gt 1GB) ?
		("{0,3:N0} GB" -f ($size / 1GB)) :
	($size -gt 1MB) ?
		("{0,3:N0} MB" -f ($size / 1MB)) :
		("{0,3:N0} KB" -f ($size / 1KB))
}

function Get-Ancestors {
	[CmdletBinding()]
	param (
		# Specifies a path to one or more locations. Wildcards are permitted.
		[Parameter(Mandatory = $true,
			Position = 0,
			ParameterSetName = "Child",
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = "Path to one or more locations.")]
		[ValidateNotNullOrEmpty()]
		[SupportsWildcards()]
		[ValidateScript({ $_ | Test-Path })]
		[string[]]
		$path
	)
		
	process {

	}
	# [Parameter()]
	# [switch]$ParameterName
}

# Invoke-Command {
	
# }
function Get-Environment {
	[hashtable]$environmentPaths = @{}
	foreach ($environmentVariableTarget in ([System.EnvironmentVariableTarget].GetEnumNames().Length - 1)..0) {
		$environmentTarget = [System.EnvironmentVariableTarget].GetEnumName($environmentVariableTarget)
		$environmentPath = [System.Environment]::GetEnvironmentVariable('PATH', $environmentTarget)
		$environmentPaths[$environmentTarget] = $environmentPath | Expand-Path
	}
	$environmentPaths
}

function Write-WebRequest {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ValueFromRemainingArguments, Position = 0, Mandatory = $true)]
		[string]
		$Uri
	)
	Invoke-WebRequest -Uri $Uri -OutFile (Split-Path -Path $Uri -Leaf)
}
function Remove-Duplicates {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline)]
		[string[]]$locations
	)
		
	begin {
		$private:array = [System.Collections.ArrayList]::new()
	}
		
	process {
		if (-not $array.Contains($_)) {
			$array[$array.Add($_)]
		}
	}
		
	clean {
		Remove-Variable array
	}
}
# function f { [CmdletBinding(PositionalBinding)] param([Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName,ValueFromRemainingArguments)][ValidateNotNullOrEmpty()][SupportsWildcards()][string[]]$path) process { foreach ($item in $path) { if (Test-Path $item) { $provider = $null ; Write-Output $PSCmdlet.SessionState.Path.GetResolvedProviderPathFromPSPath($path, [ref]$provider) ; $provider } } } } f '~/do*'
function Get-DevelopmentEnvironment {
	[CmdletBinding(DefaultParameterSetName = "Default", PositionalBinding)]
	param (
		[Parameter(ParameterSetName = "Default", Position = 0)]
		[ValidateSet('mamba', 'bison', 'flex', 'chocolatey', 'dotnet', 'vcpkg', 'posh', 'vulkan')][string]$developmentEnvironment
	)
	# cmake -G Ninja .. -DCMAKE_BUILD_TYPE=Release --install-prefix $PWD/../install -DCMAKE_MAKE_PROGRAM="$Env:ProgramFiles\Meson\ninja.exe" -DBISON_EXECUTABLE="$Env:USERPROFILE\zip\win_flex_bison-2.5.52\win_bison.exe" -DFLEX_EXECUTABLE="$Env:USERPROFILE\zip\win_flex_bison-2.5.52\win_flex.exe"
	$mambaEnvironment = [hashtable]@{
		'MAMBA_ROOT_PREFIX' = (Join-Path $Env:APPDATA micromamba)
		'MAMBA_EXE'         = (Join-Path $Env:LOCALAPPDATA micromamba micromamba.exe)
	}
	# [PSCustomObject]@{
	# 	mamba = Value
	# }
	switch ($developmentEnvironment) {
		'mamba' {
			return [PSCustomObject]@{
				'MAMBA_ROOT_PREFIX' = (Join-Path $Env:APPDATA micromamba)
				'MAMBA_EXE'         = (Join-Path $Env:LOCALAPPDATA micromamba micromamba.exe)
			}
			
			break
		}
		'bison' {
			$path = Join-Path $Env:USERPROFILE zip "win_*$developmentEnvironment*" "*$developmentEnvironment*.exe"
			
			$provider = $null

			Set-Variable -Name ${developmentEnvironment}Executable @{
				Value = ($psCmdlet.SessionState.Path.GetResolvedProviderPathFromPSPath($path, [ref]$provider))
			}
			Set-Variable -Name ${developmentEnvironment}Path @{
				Value = (Split-Path $file -Parent)
			}

			write-output ${"$($developmentEnvironment)Environment"} # = ([hashtable]@{
			# 'WIN_FLEX_BISON'=(Get-Variable ${developmentEnvironment}Path)
			# 'FLEX_INCLUDE'=(Get-Variable ${developmentEnvironment}Path)
			# })

			return [ref]$flexEnvironment ; break
		}
		'flex' {
			$path = Join-Path $Env:USERPROFILE zip "win_*$developmentEnvironment*" "*$developmentEnvironment*.exe"
			
			$flexProvider = $null

			$flexExecutable = $psCmdlet.SessionState.Path.GetResolvedProviderPathFromPSPath($path, [ref]$flexProvider)
			$flexPath = Split-Path $file -Parent

			$flexEnvironment = [hashtable]@{
				'WIN_FLEX_BISON' = [ref]$flexPath
				'FLEX_INCLUDE'   = [ref]$flexPath
			}

			Set-Variable -name "$($developmentEnvironment.ToUpper())_EXE" -Value [ref]$flexExecutable
			Set-Variable -name "$($developmentEnvironment.ToUpper())_CONFIG" -Value [ref]$flexEnvironment

			return [ref]$flexEnvironment ; break
		}
		{ $_ -match "flex|bison" } {
			
		}
		'chocolatey' {
			return [pscustomobject]@{
				'ChocolateyInstall'       = (Join-Path $Env:ALLUSERSPROFILE chocolatey)
				'ChocolateyToolsLocation' = (Join-Path $Env:ALLUSERSPROFILE chocolatey tools)
			}
			break
		}
		'dotnet' {
			return [PSCustomObject]@{
				'DOTNET_ROOT'      = (Join-Path ${env:ProgramFiles} dotnet)
				'DOTNET_ROOT(x86)' = (Join-Path ${env:ProgramFiles(x86)} dotnet)
			}

			break
		}
		'vcpkg' {
			return [pscustomobject]@{
				'VCPKG_ROOT' = (Join-Path $Env:USERPROFILE Documents GitHub vcpkg)
			}

			break
		}
		'posh' {
			return [PSCustomObject]@{
				'POSH_INSTALLER'   = 'manual'
				'POSH_THEMES_PATH' = (Join-Path $Env:LOCALAPPDATA Programs oh-my-posh themes)
			}

			break
		}
		'vulkan' {
			return [PSCustomObject]@{
				'VK_SDK_PATH' = (Join-Path $Env:ProgramFiles VulkanSDK '1.3.275.0')
				'VULKAN_SDK'  = (Join-Path $Env:ProgramFiles VulkanSDK '1.3.275.0')
			}

			break
		}
	}
}
function Get-DevelopmentPath {
	[CmdletBinding(DefaultParameterSetName = "Default")]
	[OutputType([string[]])]
	param (
		[Parameter(ParameterSetName = "Default")]
		[ValidateSet('mamba', 'bison', 'flex', 'vcpkg', 'dotnet', 'chocolatey', 'perl', 'posh')][string]$developmentEnvironment
	)

	switch ($developmentEnvironment) {
		'mamba' {
			return Join-Path $Env:LOCALAPPDATA micromamba
			break
		}
		'bison' {}
		'flex' {
			return Join-Path $Env:USERPROFILE zip 'win_flex_bison-2.5.25'
			break
		}
		'vcpkg' {
			return Join-Path $Env:VCPKG_ROOT
			break
		}
		'dotnet' {
			return @(
				Join-Path $Env:USERPROFILE .dotnet tools
				${Env:DOTNET_ROOT}
				${Env:DOTNET_ROOT(x86)}
			)
			break
		}
		'chocolatey' {
			return Join-Path $Env:ChocolateyInstall bin
			break
		}
		'perl' {
			return @(
				(Join-Path $Env:ALLUSERSPROFILE Strawberry c bin)
				(Join-Path $Env:ALLUSERSPROFILE Strawberry perl site bin)
				(Join-Path $Env:ALLUSERSPROFILE Strawberry perl bin)
			)
			break
		}
		'posh' {
			return @(
				(Join-Path $Env:LOCALAPPDATA Programs oh-my-posh bin)
			)
		}

		# C:\ProgramData\Strawberry\c\bin
	}
}

function Get-DevelopmentModule {
	[CmdletBinding(DefaultParameterSetName = "Default")]
	param (
		[Parameter(ParameterSetName = "Default")]
		[ValidateSet('vs', 'powertoys', 'vcpkg')]
		[string]
		$developmentEnvironment
	)
	
	switch ($developmentEnvironment) {
		'vs' { return 'C:\Program Files\Microsoft Visual Studio\2022\Preview\Common7\Tools\Microsoft.VisualStudio.DevShell.dll' }
		'powertoys' { return 'C:\Program Files\PowerToys\WinGetCommandNotFound.psd1' }
		'vcpkg' { return 'C:\Users\power\Documents\GitHub\vcpkg\scripts\posh-vcpkg' }	
	}
}

function Invoke-DeveloperTool {
	[CmdletBinding(DefaultParameterSetName = "Default")]
	param (
		[Parameter(ParameterSetName = "Default")]
		[ValidateSet('vs', 'mamba')][string]$developmentEnvironment
	)
	switch ($developmentEnvironment) {
		'mamba' {
			micromamba shell hook -s powershell | Out-String | Invoke-Expression
			break
		}
		'vs' {
			Enter-VsDevShell e5832a20 -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64" | Out-Null
			break
		}
	}
	
}
function Enable-Development {
	[CmdletBinding(DefaultParameterSetName = "Default", PositionalBinding)]
	param (	
		[Parameter(ParameterSetName = "Default", Position = 0)]
		[ValidateSet('vs', 'powertoys', 'vcpkg', 'mamba', 'flex', 'bison', 'dotnet', 'chocolatey', 'perl', 'posh', 'vulkan')]
		[string]
		$developmentEnvironment
	)
	if ($developmentEnvironment -in (Get-Command Get-DevelopmentEnvironment).Parameters.developmentEnvironment.attributes.ValidValues) {
		Write-Output "Set Environment for '$developmentEnvironment'"
		
		$environmentVariables = Get-DevelopmentEnvironment -developmentEnvironment:$developmentEnvironment

		foreach ($environmentVariable in $environmentVariables.psobject.Properties) {
			Write-Output "Setting `$Env:$($environmentVariable.name) to '$($environmentVariable.value)' for $developmentEnvironment"
			[System.Environment]::SetEnvironmentVariable($environmentVariable.name,	$environmentVariable.value)
		}
	}
	if ($developmentEnvironment -in (Get-Command Get-DevelopmentPath).Parameters.developmentEnvironment.attributes.ValidValues) {
		Write-Output "Modify `$PATH for '$developmentEnvironment'"
		[string[]]$developmentPath = Get-DevelopmentPath -developmentEnvironment:$developmentEnvironment
		$developmentPath | ForEach-Object { "Adding '$_' to `$PATH for '$developmentEnvironment'" }
		Add-Path @developmentPath
	}
	if ($developmentEnvironment -in (Get-Command Get-DevelopmentModule).Parameters.deelopmentEnvironment.attributes.ValidValues) {
		Write-Output "Import module for '$developmentEnvironment'"
		$developmentModulePath = Get-DevelopmentModule -developmentEnvironment:$developmentEnvironment
		$developmentModulePath | ForEach-Object { "Importing module '$_' to `$PATH for '$developmentEnvironment'" }
		Import-Module $developmentModulePath
	}
	if ($developmentEnvironment -in (Get-Command Invoke-DeveloperTool).Parameters.developmentEnvironment.attributes.ValidValues) {
		Write-Output "Invoke Tool for '$developmentEnvironment'"
		Invoke-DeveloperTool -developmentEnvironment:$developmentEnvironment
	}
}