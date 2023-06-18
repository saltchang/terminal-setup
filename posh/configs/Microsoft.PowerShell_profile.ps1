[cultureinfo]::CurrentUICulture = 'en-US'

# Variable

Set-Variable -Name PROJS_BASE -Value $HOME/Projects
Set-Variable -Name UNREAL_EXE -Value "C:/Program Files/Epic Games/UE_5.1/Engine/Binaries/Win64/UnrealEditor.exe"

# Setup
if (-not(Test-Path $PROJS_BASE/Personal)) {
    mkdir $PROJS_BASE/Personal
}

if (-not(Test-Path $PROJS_BASE/Library)) {
    mkdir $PROJS_BASE/Library
}

if (-not(Test-Path $PROJS_BASE/Personal/Games)) {
    mkdir $PROJS_BASE/Personal/Games
}

if (-not(Test-Path $PROJS_BASE/Work)) {
    mkdir $PROJS_BASE/Work
}

if (-not(Test-Path $PROJS_BASE/Archived)) {
    mkdir $PROJS_BASE/Archived
}

# Oh My Posh
oh-my-posh init pwsh --config "~/OneDrive/Documents/PowerShell/.nozo.omp.json" | Invoke-Expression
# Import-Module posh-git
# $env:POSH_GIT_ENABLED = $true

# PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function Complete

# Alias
Set-Alias -Name edit -Value code

# Functions
function home {
    Set-Location $HOME
    Write-Output "Welcome home!"
}

function goj {
    Set-Location $PROJS_BASE
    Write-Output "OK, ready to do something amazing :)"
}

function gow {
    Set-Location $PROJS_BASE/Work
    Write-Output "OK, ready to work :)"
}

function gop {
    Set-Location $PROJS_BASE/Personal
    Write-Output "OK, ready to do something amazing :)"
}

function gol {
    Set-Location $PROJS_BASE/Library
    Write-Output "OK, you are now in the Library :)"
}

function gog {
    Set-Location $PROJS_BASE/Personal/Games
    Write-Output "OK, ready to do something amazing :)"
}

function goa {
    Set-Location $PROJS_BASE/Archived
    Write-Output "OK, ready to do check the archived files :)"
}

function edit-rc {
    Invoke-Expression "& `"edit`" `"C:/Users/Salt/OneDrive/Documents/PowerShell`""
}

function unreal {
    param (
        $UnrealProjectPath
    )

    $proj_path = (Get-Item $UnrealProjectPath | ForEach-Object { $_.FullName })
    Write-Output "-> Starting Unreal Project..."
    Write-Output "-> Project: $proj_path"
    Invoke-Expression "& `"$UNREAL_EXE`" `"$proj_path`""
}


function open {
    param (
        $target_dir
    )

    if ($null -eq $target_dir) {
        Invoke-Expression "& `"explorer.exe`" `".`""
        return
    }

    $full_path = (Get-Item $target_dir | ForEach-Object { $_.FullName })
    Invoke-Expression "& `"explorer.exe`" `"$full_path`""
}

# $Env:Path += ";$HOME/bin"
