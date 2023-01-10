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

# Oh My Posh
oh-my-posh init pwsh --config "$env:HOME/OneDrive/Documents/PowerShell/.nozo.omp.json" | Invoke-Expression
Import-Module posh-git

# PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function Complete

# Alias
Set-Alias -Name edit -Value code
Set-Alias -Name "edit-rc" -Value "edit $env:HOME/OneDrive/Documents/PowerShell"

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

function unreal {
    param (
        $UnrealProjectPath
    )

    $proj_path = (Get-Item $UnrealProjectPath | % { $_.FullName})
    Write-Output "-> Starting Unreal Project..."
    Write-Output "-> Project: $proj_path"
    Invoke-Expression "& `"$UNREAL_EXE`" `"$proj_path`""
}

# $Env:Path += ";$HOME/bin"
