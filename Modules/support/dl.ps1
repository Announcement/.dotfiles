Write-Output $args

# curl --silent https://www.xvideos.com/video76542003/oh_no_i_took_viagra_by_accident_bigtits_stepmom_ | rg -o https?://.+.m3u8 | Out-File target
# curl --silent -O $(Get-Content target)
# Get-Content *.m3u8 | rg ^\w+ | ForEach-Object { curl --silent -O "$($(Get-Content target) -replace ([uri]"$(Get-Content target)").Segments[-1],$_)" }
# Get-Content *.m3u8 | rg ^\w+ | ForEach-Object { curl --silent -O "$($(Get-Content target) -replace ([uri]"$(Get-Content target)").Segments[-1],$_)" }
# # Get-ChildItem *.m3u8 | % { $playlist = $_; Get-Content $playlist | rg ^\w+ | % { "$playlist file '$_'" } }

# Get-ChildItem *.m3u8 | Select-Object -ExpandProperty FullName | ForEach-Object { $playlist = $($_ | rg --pcre2 "[^\\\/]+(?=\.\w+)" -o); Get-Content $_ | rg ^\w | Out-File -Encoding unicode "$playlist.txt" ; ffmpeg -f concat -i "$playlist.txt" -c copy "$playlist.ts" ; ffmpeg -i $playlist.ts -acodec copy -vcodec copy $playlist.mp4 }

# # foreach (file in Get-ChildItem *.m3u7) {
# #     file
# # }
# # Get-Content *.m3u8 | rg ^\w+ | ForEach-Object { Out-File "file '$_'" }

# # Get-Content *.m3u8 | rg ^\w+ | % { curl --silent -O "$($(Get-Content target) -replace ([uri]"$(Get-Content target)").Segments[-1],$_)" }

# .\downloads\ffmpeg-6.0-essentials_build\ffmpeg-6.0-essentials_build\bin\ffmpeg.exe -i .\all.ts -acodec copy -vcodec copy all.mp4
# ffmpeg -f concat -i mylist.txt -c copy all.ts