# Get-ChildItem -Recurse -Depth 3 | Where-Object -Property LinkType
# # $currentLocation = Get-Location

# # Push-Location $Env:USERPROFILE
# # Push-Location pkg
# Set-Variable -Name Commands -Value $(Get-ChildItem $Env:USERPROFILE\pkg\d | Group-Object -Property BaseName)
# Set-Variable -Name CommandList -Value []

# # Set-Variable -Name CustomCommands -Value [PSCustomObject]@();


# $Commands |
# ForEach-Object {
#     $Object = $([PSCustomObject]@{
#         Command = $_.Name
#         # Value = $_.Group
#     })
#     Set-Variable -Scope $Object -Name $_.Name -Value $_.Group | ForEach-Object {
#         fsutil hardlink list $_.FullName
#     }
# }
Get-ChildItem $Env:USERPROFILE\pkg\d |
Group-Object -Property BaseName |
ForEach-Object {
#     # Write-Host  -NoNewline -ForegroundColor Black
#     # Write-Host $($_.Name -replace "\.exe","")
#     # Write-Host "`e[4m$($_.Name -replace '\.exe','')`e[24m"
#     # Write-Host "`e[4m$($_.Name)`e[24m"
#     # $List = $_.Group | % { fsutil hardlink list $_.Fullname }
#     [PSCustomObject]@{
#         # Name = $_.Name
#         $_.Name = $($_.Group | % { fsutil hardlink list $_.Fullname })
#     }
#     # $inner
    $_.Group |
    ForEach-Object {
#     #     # Write-Output $_
        fsutil hardlink list $_.FullName | Resolve-Path -Relative |
        # Resolve-Path -Relative |
        ForEach-Object { $_ -replace '\\','/' -replace '\./','' }
        # ForEach-Object { $_ -replace '\./','' }

    }
} | ConvertTo-Json
#     #     # @{

#     #     # }
#     #     # ForEach-Object { Write-Host -NoNewline $($(Resolve-Path -Relative $_) -replace '\\','/' -replace '\./','')} ;
#     #     # Write-Output ""
#     # } | Get-Member | ? { $_.MemberType -eq "Property" }

#     # fsutil hardlink list $_.FullName |
#     # ForEach-Object { $(Resolve-Path -Relative $_) -replace '\\','/' -replace '\./','' } ;
    
#     # Write-Output ""
# }

# # Pop-Location
# # Pop-Location

# # $c = [enum]::GetValues([System.ConsoleColor])
# # $m = ($c | ForEach-Object { "$_".Length } | Measure-Object -Maximum).Maximum

# #  #Get the list of colors and hex equivalents
# #  [windows.media.colors] | Get-Member -Static -MemberType property | 
# #  ForEach-Object { 
# #  $psISE.Options.ConsolePaneTextBackgroundColor = `
# #  ([windows.media.colors]::$($_.name)).tostring() 
# #  "$($_.name) `t $([windows.media.colors]::$($_.name))" 
# #  }


# [enum]::GetValues([System.ConsoleColor]) | ForEach-Object { $b = $_ ; [enum]::GetValues([System.ConsoleColor]) | ForEach-Object { $f = $_ ; @{ "Background" = $b ; "Foreground" = $f } } } | Where-Object { $_.Foreground -ne $_.Background } | Sort-Object -Property Foreground | ForEach-Object { Write-Host -ForegroundColor $_.Foreground -BackgroundColor $_.Background "$_" -NoNewline }
# foreach ($f in $c) {
#     write-host (" {0,$m} " -f [string]"$f") -NoNewline
# }

# foreach ($b in $c) {
#     foreach ($f in $c) {
#         if ($b -eq $f) {
#             write-host (" {0,$m} " -f [string]"$b") -NoNewline
#         } else {
#             write-host -BackgroundColor $b -ForegroundColor $f "----" -NoNewline
#         }
#     }
#     write-host ""
# }