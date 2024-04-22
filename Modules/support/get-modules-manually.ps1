# $Env:PSModulePath.Split(';') | Get-Item | Select-Object -ExpandProperty FullName

Get-Content Env:\PSModulePath | ForEach-Object Split ';' | Get-Item | ForEach-Object -Parallel {
	$modulePath = $_
	# Write-Host $modulePath
	$modulePath | Get-ChildItem | ForEach-Object -Parallel {
		$moduleDirectory = $_
		
		$modulePath = $using:modulePath
		$currentModulePath = [System.IO.Path]::GetRelativePath($modulePath, $moduleDirectory)
		$currentModule = [pscustomobject]@{
			Name = ($currentModulePath)
			# Root = ($modulePath)
			# Home = ($moduleDirectory)
			Files = ($moduleDirectory | Get-ChildItem -Recurse -File -Include "*.psd1","*.psm1","*.ps1","*.dll")
		}
		Add-Member -InputObject $currentModule -NotePropertyName ModulePath -NotePropertyValue ($modulePath)
		Add-Member -InputObject $currentModule -NotePropertyName ModuleDirectory -NotePropertyValue ($moduleDirectory)
		$currentModule
		# }
		# $moduleDirectory |  | ForEach-Object -Parallel {
		# 	$moduleFile = $_

		# 	$modulePath = $using:modulePath
		# 	$moduleDirectory = $using:moduleDirectory
			
		# 	$currentModulePath = [System.IO.Path]::GetRelativePath($modulePath, $moduleDirectory)
		# 	$currentModuleFile = [System.IO.Path]::GetRelativePath($moduleDirectory, $moduleFile)

		# 	[PSCustomObject]@{
		# 		Name = ($currentModulePath)
		# 		File = ($currentModuleFile)
		# 		# Extension = ($moduleFile.Extension)
		# 		# File = ($moduleFile)
		# 		Root = ($modulePath)
		# 		# Home = ($moduleDirectory)
		# 	}
		# }
	}
}# | Sort-Object -Stable -Property Root,Name,File | Format-Table -GroupBy Name File
# [PSCustomObject]@{
# 			Name = ($currentModulePath)
# 			Root = ($modulePath)
# 			Home = ($moduleDirectory)
# 		}
# foreach ($modulePath in $modulePaths) {
# 	$moduleDirectories = $modulePath | Get-ChildItem
# 	# Write-Host $modulePath -ForegroundColor Green
# 	foreach ($moduleDirectory in $moduleDirectories) {
# 		$currentModulePath = [System.IO.Path]::GetRelativePath($modulePath, $moduleDirectory)

# 		$moduleFiles = Get-ChildItem -Recurse -File
# 		foreach ($moduleFile in $moduleFiles) {
# 			Write-Host [PSCustomObject]@{
# 				# Name = ($currentModulePath)
# 				Extension = ($moduleFile.Extension)
# 				# File = ($moduleFile)
# 				# Root = ($modulePath)
# 				# Home = ($moduleDirectory)
# 			}
# 		}
# 		# Write-Host -ForegroundColor Green ()
# 	}
# }
# }
#  | Get-ChildItem | 
# ForEach-Object {
# 	Write-Host -ForegroundColor Blue "`n$_`n"
# 	$modulePath = $_;
# 	$_ | Get-ChildItem -Include "*.psd1","*.psm1","*.format.ps1xml" | Where-Object LastWriteTime -GT (Get-Date).AddDays(-7)
# }
# # $Env:PSModulePath.Split(';') | Get-Item |
# # ForEach-Object {
# # 	$currentModulePath = $_;
# # 	Write-Host -ForegroundColor Green `n $currentModulePath.FullName ;
# # 	$currentModulePath |
# # 	Get-ChildItem -Recurse |
# # 	Where-Object LastWriteTime -GT (Get-Date).AddHours(-1) |
# # 	Get-ChildItem -Recurse -File -Include *.psd1,*.psm1 ; |
# # 	% { Join-Path (Resolve-Path -RelativeBasePath $currentModulePath -Path $_ -Relative |
# # 		Split-Path -Parent | Split-Path -Leaf) $_.Name } } -Debug

# # # $Env:PSModulePath.Split(';') | % { $currentModulePath = $_ | Get-Item; Write-Host -ForegroundColor Green `n $currentModulePath.FullName ; $currentModuleManifests = $currentModulePath | Get-ChildItem -Recurse | Where-Object LastWriteTime -GT (Get-Date).AddHours(-1) | Get-ChildItem -Recurse -File -Include *.psd1,*.psm1 ; | % { Join-Path (Resolve-Path -RelativeBasePath $currentModulePath -Path $_ -Relative | Split-Path -Parent | Split-Path -Leaf) $_.Name } } -Debug

# # # Set-PSBreakpoint -Variable PSModulePaths

# $modulePaths = $Env:PSModulePath.Split(';') | Get-Item;

# foreach ($modulePath in $modulePaths) {
# 	Write-Host -ForegroundColor Green "`n" $modulePath
# 	$modulePath |
# 	Get-ChildItem -Recurse -Include "*.format.ps1xml","*.psm1","*.psd1" |
# 	Where-Object LastWriteTime -GT (Get-Date).AddDays(-7) |
# 	ForEach-Object { [System.IO.Path]::GetRelativePath($modulePath, $_) }
# }
# # # Write-Debug $PSModulePaths.psobject.getty

# # # Class SoundNames : System.Management.Automation.IValidateSetValuesGenerator {
# # #     [string[]] GetValidValues() {
# # #         $SoundPaths = '/System/Library/Sounds/',
# # #             '/Library/Sounds','~/Library/Sounds'
# # #         $SoundNames = ForEach ($SoundPath in $SoundPaths) {
# # #             If (Test-Path $SoundPath) {
# # #                 (Get-ChildItem $SoundPath).BaseName
# # #             }
# # #         }
# # #         return [string[]] $SoundNames
# # #     }
# # # }

# # # $PSModulePaths.BaseName
# # function Get-ModulesManually {
# #   [CmdletBinding(DefaultParameterSetName = "Module Paths")]
# #   param(
# # 	[parameter(Mandatory, ParameterSetName = "Environment", Position = 0)]
# # 	[ValidateScript(
# # 		$_.Split([System.IO.Path]::PathSeparator);
# # 	)]
# # 	[string]$Path = $Env:PSModulePath,

# # 	[parameter(Mandatory, ParameterSetName = "Path", ValueFromPipeline)]
# # 	[ValidateScript(

# # 	)]
# # 	[string[]]$modulePaths,

# # 	[parameter(Mandatory, ParameterSetName = "Module", ValueFromPipeline)]
# # 	[ValidateScript(

# # 	)]
# # 	[FileSystemInfo[]]$modules,

# # 	[parameter(Mandatory, ParameterSetName = "Import", ValueFromPipeline)]
# # 	[ValidateScript(

# # 	)]
# # 	[PSModuleInfo[]]$imports

# #   )

# #   begin {
# # 	# [Collections.ArrayList]$inputObjects = @()
# #   }
# #   process {
# # 	foreach ($modulePath in $modulePaths) {
# # 		Write-Host -ForegroundColor Green "`n" $modulePath
# # 	}
# # 	# [void]$inputObjects.Add($)
# #   }
# #   end {
# # 	# $inputObjects | Foreach -Parallel {
	  
# # 	# }
# #   }
# # }

# # # function Get-ModuleManually {
# # #     param (
# # #         [Parameter(Mandatory, ParameterSetName="Module")]
# # #         [string]$modulePath
# # #     )
	 
# # #     process {
		
# # #         Write-Host -ForegroundColor Green `n $currentModulePath.FullName ; $currentModuleManifests = $currentModulePath | Get-ChildItem -Recurse | Where-Object LastWriteTime -GT (Get-Date).AddHours(-1) | Get-ChildItem -Recurse -File -Include *.psd1,*.psm1 ; | % { Join-Path (Resolve-Path -RelativeBasePath $currentModulePath -Path $_ -Relative | Split-Path -Parent | Split-Path -Leaf) $_.Name } } -Debug
# # #     }
# # # }

# # Get-ModulesManually $PSModulePaths
# # # | % { $currentModulePath = $_ | Get-Item; Write-Host -ForegroundColor Green `n $currentModulePath.FullName ; $currentModuleManifests = $currentModulePath | Get-ChildItem -Recurse | Where-Object LastWriteTime -GT (Get-Date).AddHours(-1) | Get-ChildItem -Recurse -File -Include *.psd1,*.psm1 ; | % { Join-Path (Resolve-Path -RelativeBasePath $currentModulePath -Path $_ -Relative | Split-Path -Parent | Split-Path -Leaf) $_.Name } } -Debug