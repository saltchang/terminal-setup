# ~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1

# Oh My Posh

Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme ~\.nozo.omp.json

# PSReadLine

Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function Complete

$Env:Path += ";C:\Users\saltchang\apps\gotop"
