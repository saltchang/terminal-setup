[cultureinfo]::CurrentUICulture = 'en-US'

# Variable

Set-Variable -Name PROJS_BASE -Value $HOME/Projects
Set-Variable -Name UNREAL_EXE -Value "C:/Program Files/Epic Games/UE_5.1/Engine/Binaries/Win64/UnrealEditor.exe"

# Setup
if (-not(Test-Path $PROJS_BASE/Personal)) {
    mkdir $PROJS_BASE/Personal
}

if (-not(Test-Path $PROJS_BASE/Work)) {
    mkdir $PROJS_BASE/Work
}

if (-not(Test-Path $PROJS_BASE/Archived)) {
    mkdir $PROJS_BASE/Archived
}

# Oh My Posh
oh-my-posh init pwsh --config "~/OneDrive/Documents/PowerShell/.nozo.omp.json" | Invoke-Expression
Import-Module posh-git

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
    cd $HOME
    Write-Output "Welcome home!"
}

function goj {
    cd $PROJS_BASE
    Write-Output "OK, ready to do something amazing :)"
}

function gow {
    cd $PROJS_BASE/Work
    Write-Output "OK, ready to work :)"
}

function gop {
    cd $PROJS_BASE/Personal
    Write-Output "OK, ready to do something amazing :)"
}

function goa {
    cd $PROJS_BASE/Archived
    Write-Output "OK, ready to do check the archived files :)"
}

function edit-rc {
    Invoke-Expression "& `"edit`" `"C:\Users\Salt\OneDrive\Documents\PowerShell`""
}

function unreal {
    param (
        $UnrealProjectPath
    )

    $proj_path = (Get-Item $UnrealProjectPath | % { $_.FullName})
    Write-Output "-> Starting Unreal Project..."
    Write-Output "-> Project: $proj_path"
    Invoke-Expression "& `"$UNREAL_EXE`" `"$proj_path`""
}


function open {
    param (
        $target_dir
    )

    $full_path = (Get-Item $target_dir | % { $_.FullName})
    Invoke-Expression "& `"explorer.exe`" `"$full_path`""
}

# $Env:Path += ";$HOME/bin"
