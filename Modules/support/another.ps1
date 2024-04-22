0..127 | ForEach-Object -ThrottleLimit ([System.Threading.ThreadPool]::ThreadCount) -Parallel { Measure-Command { pwsh -noni -mta -c "write-host [System.Threading.ThreadPool]::ThreadCount" } | % { (((($_.days * 24 + $_.hours) * 60 + $_.minutes) * 60 + $_.seconds) * 1000 + $_.milliseconds) } } | Measure-Object -AllStats | % { "run pwsh ∈ $($_.Count) times; μ = $($_.Average); σ = $($_.StandardDeviation) ($($_.Minimum)ms–$($_.Maximum)ms) " }


# $global:REGISTRY = [pscustomobject]@{
#   'User' = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager';
#   'System' = 'HKCU:\'
# }