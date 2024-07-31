# [regex]::new("(?<=[\r\n])(?<argument_space>\x20+)(-(?<singlet>[^-\s]+))?(--(?<argument>[_a-zA-Z0-9-]+)).+(?:(?:[\r\n]+(?<description_space>\k<argument_space>\x20+).+)([\r\n]+\k<description_space>.+|[\r\n]\s*(?=[\r\n]))*)?", [System.Text.RegularExpressions.RegexOptions]::Compiled).Matches(((rg -h) | Join-String -Separator "`n")).ForEach({ $_.Groups.where({ $_.Name -like "argument" }).value })


# All Users, All Hosts
# Windows - $PSHOME\Profile.ps1
# Linux - /opt/microsoft/powershell/7/profile.ps1
# macOS - /usr/local/microsoft/powershell/7/profile.ps1
# All Users, Current Host
# Windows - $PSHOME\Microsoft.PowerShell_profile.ps1
# Linux - /opt/microsoft/powershell/7/Microsoft.PowerShell_profile.ps1
# macOS - /usr/local/microsoft/powershell/7/Microsoft.PowerShell_profile.ps1
# Current User, All Hosts
# Windows - $HOME\Documents\PowerShell\Profile.ps1
# Linux - ~/.config/powershell/profile.ps1
# macOS - ~/.config/powershell/profile.ps1
# Current user, Current Host
# Windows - $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# Linux - ~/.config/powershell/Microsoft.PowerShell_profile.ps1
# macOS - ~/.config/powershell/Microsoft.PowerShell_profile.ps1
# ug --help | Out-String -Stream | % { $expression = [regex]::new("(?<=^\x20{4})(?=\S)-.+([\r\n]+)", [System.Text.RegularExpressions.RegexOptions]::Multiline); $expression.Match($_) ; $expression.Matches() }

# C:\Users\power\AppData\Roaming\Package\version\zig\latest

enum PSEditions {
	Core
	Desktop
}
enum Privelege {
	System
	User
	Process
}

[Flags()] enum DevelopmentEnvironment {
	Bison
	Chocolatey
	Dotnet
	Flex
	Mamba
	Perl
	Posh
	Vcpkg
	Vulkan
	Zig
	Rust
	ESP
	CMake
	Clang
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
	($size -ge 1TB) ?
		("{0,3:N0} TB" -f ($size / 1TB)) :
	($size -ge 1GB) ?
		("{0,3:N0} GB" -f ($size / 1GB)) :
	($size -ge 1MB) ?
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
	<#
	.SYNOPSIS
		Environment Path
	.DESCRIPTION
		A longer description of the function, its purpose, common use cases, etc.
	.NOTES
		Information or caveats about the function e.g. 'This function is not supported in Linux'
	.LINK
		Specify a URI to a help page, this will show when Get-Help -Online is used.
	.EXAMPLE
		Test-MyTestFunction -Verbose
		Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
	#>
	
	
	[CmdletBinding()]
	param (
		[Privelege[]]$Privelege
	)
	
	begin {
		
	}
	
	process {
		
	}
	
	end {
		
	}
}
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
		'vs' {
			$VSWHERE = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio" installer vswhere.exe
			$VSTUDIO = & $VSWHERE -Property installationPath
			return Join-Path $VSTUDIO Common7 Tools Microsoft.VisualStudio.DevShell.dll
			# $VSTUDIO = & $VSWHERE -Format JSON | ConvertFrom-Json
			# return Join-Path (& $VSWHERE -Format Value -Property installationPath) Common7 Tools Microsoft.VisualStudio.DevShell.dll
			# $VSWHERE = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
			# $installationPath = &$VSWHERE -Format value -Property installationPath

			# return "$installationPath\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
		}
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
			$VSWHERE = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio" installer vswhere.exe
			$VSTUDIO = & $VSWHERE -Property instanceId
			Enter-VsDevShell $VSTUDIO -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64" | Out-Null
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


# function global:Get-DirectoryTree
# {
# 	[CmdletBinding()]
# 	param(
# 		[Parameter(Position = 0)]
# 		[System.IO.DirectoryInfo]
# 		$referenceObject = (Get-Location | Get-Item),

# 		[Parameter(ValueFromPipeline)]
# 		[System.IO.DirectoryInfo]
# 		$inputObject = ($HOME)
# 	)
# 	#   dynamicparam {<statement list>}
# 	begin
# 	{
# 		$currentLocation = $referenceObject
# 		$referenceList = [System.Collections.ArrayList]@($currentLocation.FullName)

# 		while ($currentLocation.FullName -ne $referenceObject.Root.FullName)
# 		{
# 			$referenceList.Add($currentLocation.FullName)
# 			$currentLocation = $currentLocation.Parent
# 		}

# 		$referenceList
# 	}
# 	process
# 	{
# 		$currentLocation = $inputObject
# 		$inputList = [System.Collections.ArrayList]@($inputObject.FullName)

# 		while ($currentLocation.FullName -ne $inputObject.Root.FullName)
# 		{
# 			$inputList.Add($currentLocation.FullName)
# 			$currentLocation = $currentLocation.Parent
# 		}
# 		# $_ | Out-Default
# 		# foreach ($item in $input) {
# 		#     $item | Out-Default
# 		# }
# 		# $inputObject | Out-Default
# 		# Write-Debug "$_"
# 		# Write-Debug "$inputObject -> $referenceObject"
# 		# Write-Debug $input
# 		# $currentLocation = $inputObject;


# 		# while ($currentLocation.FullName -ne $currentLocation.Root.FullName -and $tree -notcontains $currentLocation.FullName)
# 		# { # -and $tree.Contains($currentLocation.FullName) -eq $false) {
# 		#     $tree.Add($currentLocation.FullName)
# 		#     $currentLocation = $currentLocation.Parent
# 		# }

# 		# $currentLocation.FullName
# 	}
# 	end
# 	{
# 		# $tree
# 		# $tree.join(";")
# 	}
# 	clean
# 	{
# 	}
# }
function Get-Parents {
	
	[CmdletBinding(PositionalBinding)]
	param (
		# Specifies a path to one or more locations. Wildcards are permitted.
		[Parameter(Mandatory = $true,
			Position = 0,
			ParameterSetName = "ResolvablePaths",
			ValueFromPipeline,
			# ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments,
			HelpMessage = "Path to one or more locations.")]
		[ValidateNotNullOrEmpty()]
		# [SupportsWildcards()]
		[System.IO.FileInfo[]]
		$Path
	)
	process {
		foreach ($currentItem in $Path) {
			$currentItem |
			Where-Object { $currentItem.Directory.Name -NE $currentItem.Directory.Root.Name } | 
			ForEach-Object { Get-Parents $_.Directory }
		}
		# ForEach-Object Split([System.IO.Path]::PathSeparator) |
		# ForEach-Object { param([string]$path = $_) [System.Environment]::ExpandEnvironmentVariables($path) } |
		# Where-Object { param([string]$path = $_) $path | Test-Path } |
		# Resolve-Path |
		# Get-Item
		# Where-Object { $_.Parent.Name -NE $_.Root.Name } |
		# ForEach-Object {
		# 	Get-Parents $_.Parent.n
		# };
		# $PSItem
	}
}

# function  {
#   [CmdletBinding()]
#   param(
# 	[parameter(ValueFromPipeline)]$
#   )

#   begin {
# 	[Collections.ArrayList]$inputObjects = @()
#   }
#   process {
# 	[void]$inputObjects.Add($)
#   }
#   end {
# 	$inputObjects | Foreach -Parallel {
	  
# 	}
#   }
# }

# # Specifies a path to one or more locations. Wildcards are permitted.
# [Parameter(Mandatory=$true,
# 		   Position=Position,
# 		   ParameterSetName="ParameterSetName",
# 		   ValueFromPipeline=$true,
# 		   ValueFromPipelineByPropertyName=$true,
# 		   HelpMessage="Path to one or more locations.")]
# [ValidateNotNullOrEmpty()]
# [SupportsWildcards()]
# [string[]]
# $ParameterName

function Get-FileSystemObject {
	[Alias('G-	FSO')]
	[CmdletBinding(PositionalBinding,DefaultParameterSetName="Path")]
	param (
		[Parameter(Mandatory,ParameterSetName="File",ValueFromRemainingArguments,ValueFromPipeline,ValueFromPipelineByPropertyName,Position=0)]
		[ValidateNotNull()]
		[System.IO.FileInfo[]]
		$File,

		[Parameter(Mandatory,ParameterSetName="Directory",ValueFromRemainingArguments,ValueFromPipeline,ValueFromPipelineByPropertyName,Position=0)]
		[ValidateNotNull()]
		[System.IO.DirectoryInfo[]]
		$Folder,

		# Parameter help description
		[Parameter(Mandatory,ParameterSetName='Path',ValueFromRemainingArguments,ValueFromPipeline,ValueFromPipelineByPropertyName,Position=0)]
		[ValidateNotNullOrWhiteSpace()]
		[SupportsWildcards()]
		[ValidateScript({ $null -isnot ($_ | Resolve-Path) })]
		[string[]]
		$Path
	)

	begin {
	}
	
	process {
		$filesystemObject = New-Object -ComObject Scripting.FileSystemObject
		if ($PSCmdlet.ParameterSetName.Equals('Path')) {
			$Directory, $File = ($path | Resolve-Path | Get-Item).Where({ $_.PSIsContainer }, 'Split')
		}
		$File | ForEach-Object -Parallel { $filesystemObject.GetFile($_.FullName) }
		$Directory | Foreach-Object -Parallel { $filesystemObject.GetDirectory($_.FullName) }

		# switch ($PSCmdlet.ParameterSetName) {
		# 	'File' {
		# 	}
		# 	'Directory' {
		# 	}
		# 	'Path' {

		# 		$Directory | Where-Object -Parallel { $filesystemObject.GetFolder($_) }
		# 		$File | Where-Object -Parallel { $filesystemObject.GetFile($_) }
		# 	}
		# }
	}

	end {}

	clean {

		Remove-Variable -Name fileSystemObject
	}

	# (, (Get-ChildItem -Attributes System+Hidden C:\ -Depth 2).Where({ $_.PSIsContainer }, 'Split')) | % { ($_[0] | % { $filesystemObject.GetFolder($_) }) ; ($_[1] | % { $filesystemObject.GetFile($_) }) }

}
# function Expand-Object {
# 	[CmdletBinding()]
# 	param (
# 		# Parameter help description
# 		[Parameter(ValueFromPipeline)]
# 		[psobject]
# 		$PSInputObject,
# 		[Parameter(ValueFromRemainingArguments)]
# 		[string]
# 		$groupProperty
# 	)
# 	# $keys = @($externalKeys ; $internalKeys)
# 	# $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet', [string[]]$keys)
# 	# $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)
# 	# $myobject | .
# 	# $PSInputObject |
# 	# ForEach-Object {
# 	# 	param($item = $_)
# 	# 	$item.members
# 		# $hashtable = [hashtable]@{}

# 		# foreach( $property in $item.psobject.members.properties.name)
# 		# {
# 		# 	$hashtable[$property] = $_.$property
# 		# }
# 		# $hashtable

# 		# $_[$groupProperty].GetEnumerator() |
# 		# ForEach-Object {
# 		# 	param($it = $_)
# 		# 	$hashtable.CopyTo($t)
# 		# 	foreach ( $property in $it.psobject.properties.name) {
# 		# 		$t[$property] = $it.$property
# 		# 	}
# 		# 	$t
# 		# }
# 		# # Format-Table -GroupBy TypeName Key, Value
# 	# }
# }
# Register-ArgumentCompleter -CommandName bat -ParameterName style -ScriptBlock {
# 	param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

# }

# $parser = [hashtable]@{}
# $syntax = [hashtable]@{}
# $manual = [hashtable]@{}
# $parser.bat = [regex]::new("(?<=[\r\n])\x20{2}(?:-(?<alias>\w),\x20|\x20{4})--(?<parameter>[\w-]+)(?:\x20\<(?<arguments>.+)\>)?(?<description>(?:[\r\n]+\x20{10}.*|[\r\n](?=[\r\n]))*)", [System.Text.RegularExpressions.RegexOptions]::Compiled)
# $manual.bat = (bat --help) | Join-String -Separator "`n"
# $syntax.bat = $parser.bat.Matches($manual.bat) |
#  Foreach-Object {
# 	[pscustomobject]@{
# 		"Parameter" = $_.Groups['parameter']
# 		"Alias" = $_.Groups['alias']
# 		"Arguments" = $_.Groups['arguments']
# 		"Description" = $_.Groups['description'].Value -Replace '\x20{10}', '' | ForEach-Object Trim
# 	}
# }
# $predictor = [hashtable]@{}
# $predictor.bat = {
# 	param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
# 	$syntax.bat | Where-Object Parameter -like "$wordToComplete*" | ForEach-Object {
# 		[System.Management.Automation.CompletionResult]::new($_.parameter, $_.parameter, 'ParameterValue', $_.parameter)
# 	}
# }
# # Register-ArgumentCompleter -CommandName bat -Native -ScriptBlock {
	
# # }
# Register-ArgumentCompleter -CommandName bat -ParameterName theme -ScriptBlock {
# 	param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
# 	$syntax.bat | Where-Object Parameter -like "$wordToComplete*" | ForEach-Object {
# 		[System.Management.Automation.CompletionResult]::new($_.parameter, $_.parameter, 'ParameterValue', $_.parameter)
# 	}
# }
# Register-ArgumentCompleter -CommandName bat -ParameterName language -ScriptBlock {
	
# }
# Register-ArgumentCompleter -CommandName bat -ParameterName style -ScriptBlock {
	
# }
# $services = Get-Service | Where-Object { $_.Status -eq "Running" -and $_.Name -like "$wordToComplete*" }
# $services | ForEach-Object {
# 	New-Object -Type System.Management.Automation.CompletionResult -ArgumentList $_.Name,
# 	$_.Name,
# 	"ParameterValue",
# 	$_.Name
# }
# $defaultDisplaySet = 'Name', 'Size'
# $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet', [string[]]$defaultDisplaySet)
# $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)
# $MyObject | Add-Member MemberSet PSStandardMembers $PSStandardMembers

# Get-ChildItem C:\Users\power\AppData\Roaming\Package\version\ -Directory |
# % {
#   $size = Get-ChildItem $_ -Recurse -FollowSymlink -File | % Length | Measure-Object -Sum | % Sum
#   $obj = [pscustomobject]@{
#     Name=$_.FullName.Replace("C:\Users\power\AppData\Roaming\Package\version\","")
#     Size=($size | Get-DataSize)
#     Length=$size
#   }
#   $obj | Add-Member MemberSet PSStandardMembers $PSStandardMembers
#   $obj
# } | Sort-Object -Property Length | Format-Table

# @{ Video = $video ; Title = $title ; Duration = $duration ; Thumbnail = $thumbnail ; Embed = $embed ; Tags = $tags ; Models = $models ; Id = $id ; Category = $category ; Quality = $quality }
# Get-Content ~\Downloads\xvideos.com-export-full.csv\xvideos.com-export-full.csv | % { $video, $title, $duration, $thumbnail, $embed, $tags, $models, $id, $category, $quality, $other = $_.split(';'); [pscustomobject]@{ Video = $video ; Title = $title ; Duration = $duration ; Thumbnail = $thumbnail ; Embed = $embed ; Tags = ($tags -split ',') ; Models = $models.Split(',') ; Id = $id ; Category = $category ; Quality = $quality } } | Where-Object Quality -NE 'SD' | Where-Object Tags -Like 'fake-tits' | Where-Object Tags -Like 'asian' | Format-List @{Label = "Tags"; Expression = { $_.Tags | Join-String -Separator ',' } }, Video, Duration, Models | Select-Object -First 10
# Get-Content ~\Downloads\xvideos.com-export-full.csv\xvideos.com-export-full.csv -TotalCount 100000 | % { $video, $title, $duration, $thumbnail, $embed, $tags, $models, $id, $category, $quality, $other = $_.split(';'); [pscustomobject]@{ Video = $video ; Title = $title ; Duration = $duration ; Thumbnail = $thumbnail ; Embed = $embed ; Tags = ($tags -split ',') ; Models = $models.Split(',') ; Id = $id ; Category = $category ; Quality = $quality } } | Where-Object Quality -NE 'SD' | Select-Object -ExpandProperty Tags | Where-Object { $_ -Like '*boobs*' -or $_ -like '*tits*' } | Group-Object | Sort-Object Name
# Get-Content ~\Downloads\xvideos.com-export-full.csv\xvideos.com-export-full.csv -TotalCount 1 | % { $video, $title, $duration, $thumbnail, $embed, $tags, $models, $id, $category, $quality, $other = $_.split(';'); [pscustomobject]@{ Video = $video ; Title = $title ; Duration = $duration ; Thumbnail = $thumbnail ; Embed = $embed ; Tags = ($tags -split ',') ; Models = $models.Split(',') ; Id = $id ; Category = $category ; Quality = $quality } | % { ([regex]"html5player.setVideoUrlHigh\('(.+)'\)").Match((Invoke-RestMethod -Uri $_.Video | Join-String -Separator '\n')).Groups[1].Value } | % { Invoke-WebRequest -Uri $_ -OutFile "$id.mp4" } }
# Get-Content ~\Downloads\xvideos.com-export-full.csv\xvideos.com-export-full.csv | % { $video, $title, $duration, $thumbnail, $embed, $tags, $models, $id, $category, $quality, $other = $_.split(';'); [int]$runtime = ([regex]"\d+").Match(($duration)).Groups[0].Value ; [pscustomobject]@{ Video = $video ; Title = $title ; Duration = [timespan]::new($runtime / 60 / 60, $runtime / 60 % 60, $runtime % 60) ; Thumbnail = $thumbnail ; Embed = $embed ; Tags = ($tags -split ',') ; Models = $models.Split(',') ; Id = $id ; Category = $category ; Quality = $quality } } | Where-Object Quality -NE 'SD' | Where-Object Tags -Like 'big-tits' | Where-Object Tags -Like 'asian' | Format-List @{Label = "Tags"; Expression = { $_.Tags | Join-String -Separator ',' } }, Video, Duration, Models | Select-Object -First 10
# Get-Content ~\Downloads\xvideos.com-export-full.csv\xvideos.com-export-full.csv | % { $video, $title, $duration, $thumbnail, $embed, $tags, $models, $id, $category, $quality, $other = $_.split(';'); [int]$runtime = ([regex]"\d+").Match(($duration)).Groups[0].Value ; [pscustomobject]@{ Video = $video ; Title = $title ; Duration = (New-TimeSpan -Seconds $runtime) ; Thumbnail = $thumbnail ; Embed = $embed ; Tags = ($tags -split ',') ; Models = $models.Split(',') ; Id = $id ; Category = $category ; Quality = $quality } } | Where-Object Quality -NE 'SD' | Where-Object Tags -Like 'big-tits' | Where-Object Tags -Like 'oiled' | Format-Table Duration, Title, @{Label = "Video"; Expression = { $PSStyle.FormatHyperlink($_.Quality, $_.Video) }}
# Get-ChildItem -Path C:\Users\power\Downloads\ -Directory | % { [pscustomobject]@{ "Name"=($_.Name);"Size"=(Get-ChildItem -Recurse $_ | Measure-Object -Property Length -Sum) | % Sum } } | Sort-Object -Property Size | Format-Table Name,@{Label="Size";Expression={$_.Size | Get-DataSize }}

# function Update-Package {

# }

function Reset-Package {
	[CmdletBinding()]
	param (
		[Parameter(
			Mandatory=$false,
			ValueFromRemainingArguments
		)]
		[ValidateNotNullOrEmpty()]
		[SupportsWildcards()]
		[string]
		$Path
	)
	Get-ChildItem -Directory $INSTALL/version |
	Where-Object { Test-Path $_/latest } |
	ForEach-Object { Get-ChildItem $_/latest/*.exe } |
	Where-Object { -not $INSTALL.GetFiles($_.Name).Exists } |
	ForEach-Object { New-Item -i s -p "$INSTALL" -n $_.Name -v (Join-Path version $_.Directory.Parent.BaseName latest $_.Name) }
		# [System.IO.DirectoryInfo]$INSTALL = "$env:APPDATA\Package" | Get-Item
		# [System.IO.DirectoryInfo[]]$VERSIONS = $INSTALL | Get-ChildItem -Directory
		# [System.IO.DirectoryInfo[]]$PACKAGES = $PSBoundParameters.ContainsKey('Path') ? (Get-ChildItem -Directory $VERSIONS -Filter $Path) : (Get-ChildItem -Directory $VERSIONS) # $VERSIONS.GetDirectories($Path) : $VERSIONS.GetDirectories()

		# $BINARIES = $PACKAGES.GetDirectories('latest').GetFiles('*.exe').Where({ -not (Get-Item "$env:APPDATA\Package").GetFiles($_.Name).Exists })

		# foreach ($BINARY in $BINARIES) {
		# 	New-Item -ItemType SymbolicLink -Path $INSTALL -Name ${BINARY.Name} -Value (Join-Path version ${BINARY.Directory.Parent.BaseName} latest ${BINARY.Name})
		# }


}
function Set-Package {
	[CmdletBinding(PositionalBinding, DefaultParameterSetName="LiteralPath")]
	param (
		# Specifies a path to one or more locations. Unlike the Path parameter, the value of the LiteralPath parameter is
		# used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters,
		# enclose it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any
		# characters as escape sequences.
		# [Parameter(Mandatory=$true,
		# 		   Position=0,
		# 		   ParameterSetName="LiteralPath",
		# 		   ValueFromPipelineByPropertyName=$true,
		# 		   HelpMessage="Literal path to one or more locations.")]
		# [Alias("PSPath")]
		# [ValidateNotNullOrEmpty()]
		# [SupportsWildcards()]
		# [string]
		# $LiteralPath,
		
		# Specifies a path to one or more locations. Wildcards are permitted.
		[Parameter(Mandatory=$true,
		Position=0,
		ParameterSetName="Path",
		ValueFromPipeline=$true,
		ValueFromPipelineByPropertyName=$true,
		HelpMessage="Path to one or more locations.")]
		[Alias("Package")]
		[ValidateNotNullOrEmpty()]
		[SupportsWildcards()]
		[string]
		$Path,

		# Specifies a path to one or more locations. Wildcards are permitted.
		[Parameter(Mandatory = $true,
			Position = 1,
			ParameterSetName = "Path"
		)]
		[Parameter(Mandatory = $true,
			Position = 1,
			ParameterSetName = "LiteralPath"
		)]
		[Parameter(
				   ValueFromPipeline=$true,
				   ValueFromPipelineByPropertyName=$true,
				   HelpMessage="path to latest version")]
		[ValidateNotNullOrEmpty()]
		[SupportsWildcards()]
		[version]
		$latest
	)

	[System.IO.DirectoryInfo[]]$INSTALL = "$env:APPDATA\Package" | Get-Item
	[System.IO.DirectoryInfo[]]$VERSIONS = $INSTALL.GetDirectories('Version')
	[System.IO.DirectoryInfo[]]$PACKAGE = $VERSIONS.GetDirectories($Path)

	[System.IO.DirectoryInfo[]]$PREVIOUS = $PACKAGE.GetDirectories('latest')
	[System.IO.DirectoryInfo[]]$CURRENT = $PACKAGE.GetDirectories($latest)

	# [System.IO.FileInfo[]]$BINARIES = $INSTALL.GetFiles('*.exe')
	[System.IO.FileInfo[]]$PREVIOUS_BINARIES = $PREVIOUS.GetFiles('*.exe')
	[System.IO.FileInfo[]]$CURRENT_BINARIES = $CURRENT.GetFiles('*.exe')

	$QUEUE_REMOVE = $PREVIOUS_BINARIES.Where({ $CURRENT_BINARIES.Name -inotcontains $_ })
	$QUEUE_INSTALL = $CURRENT_BINARIES.Where({ $PREVIOUS_BINARIES.Name -inotcontains $_ })

	Write-Output 'Remove: ' $QUEUE_REMOVE
	Write-Output 'Install: ' $QUEUE_INSTALL
	
	New-Item -ItemType Junction (Join-Path $PACKAGE 'latest') ${CURRENT.FullName}

	$QUEUE_INSTALL.

	# [string]$INSTALL = "$env:APPDATA\Package"

	# switch ($PSCmdlet.ParameterSetName) {
	# 	'Path' {
	# 		$Path |
	# 		ForEach-Object Split([System.IO.Path]::PathSeparator) |
	# 		Where-Object { param($path = $_) $path | ForEach-Object { Test-Path "$INSTALL\$_" } } |
	# 		Resolve-Path |
	# 		Get-Item |
	# 		ForEach-Object FullName |
	# 		Remove-Duplicates |
	# 		Resolve-Path -Relative
	# 	}
	# 	'LiteralPath' {}
	# }

	[string]$previousPath = "$INSTALL\version\$package\latest"
	[string]$currentPath = "$INSTALL\version\$package\$latest"

	[System.IO.DirectoryInfo]$currentInstall = (Get-Item $currentPath).ResolvedTarget
	[System.IO.FileInfo[]]$currentBinaries = Get-ChildItem $currentPath -Filter "*.exe"

	[string]$currentVersion = $currentInstall.Name

	Write-Debug [PSCustomObject]@{
		Previous = $previousVersion
		Current  = $currentVersion
	}

	if (Test-Path $previousPath) {
		[System.IO.DirectoryInfo]$previousInstall = (Get-Item $previousPath).ResolvedTarget
		[System.IO.FileInfo[]]$previousBinaries = Get-ChildItem $previousPath -Filter "*.exe"

		[string]$previousVersion = $previousInstall.Name

		[System.IO.FileInfo[]]$additionalBinaries = $currentBinaries | Where-Object Name -NotIn ($previousBinaries.Name)
		[System.IO.FileInfo[]]$removedBinaries = $previousBinaries | Where-Object Name -NotIn ($currentBinaries.Name)

		foreach ($removedBinary in $removedBinaries) {
			Remove-Item $INSTALL/${removedBinary.Name}
		}

		Write-Debug [PSCustomObject]@{
			Installing = $additionalBinaries
			Removing = $removedBinaries
		}

		Remove-Item $previousPath
	} else {
		[System.IO.FileInfo[]]$additionalBinaries = $currentBinaries

		foreach ($binary in $additionalBinaries) {
			New-Item -ItemType SymbolicLink $INSTALL -Name $EXECUTABLE -Value $currentPath\${binary.Name}
		}

		Write-Debug [PSCustomObject]@{
			Installing = $additionalBinaries
		}
	}
	
	foreach ($binary in $currentBinaries) {
		if (-not (Test-Path $INSTALL\${binary.name})) {
			New-Item -ItemType SymbolicLink $INSTALL -Name $EXECUTABLE -Value $currentPath\${binary.Name}
		}
	}

	New-Item -ItemType Junction $previousPath -Value $currentPath
}