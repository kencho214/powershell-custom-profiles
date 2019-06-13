# sudo
function Invoke-CommandRunAs
{
    $cd = (Get-Location).Path
    $commands = "Set-Location $cd; Write-Host `"[Administrator] $cd> $args`"; $args; Pause; exit"
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($commands)
    $encodedCommand = [Convert]::ToBase64String($bytes)
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit","-encodedCommand",$encodedCommand
}

Set-Alias sudo Invoke-CommandRunAs

function Start-RunAs
{
    $cd = (Get-Location).Path
    $commands = "Set-Location $cd; (Get-Host).UI.RawUI.WindowTitle += `" [Administrator]`""
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($commands)
    $encodedCommand = [Convert]::ToBase64String($bytes)
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit","-encodedCommand",$encodedCommand
}

Set-Alias su Start-RunAs

# grep
function grep { Select-String $args }

# printenv
function printenv { Get-ChildItem Env: }

# which
function which { (Get-Command $args).Definition }

# where
Remove-Item alias:where -Force
function where { (Get-Item (Get-Command $args).Path).Directory.FullName }

# pwd
Remove-Item alias:pwd -Force
function pwd { $(Get-Location).Path }

# touch
function touch { Write-Host "" > $args }

# vim
function vim {
  $vim = (Join-Path (Get-Item (Get-Command git).Path).Directory.Parent.FullName "usr\bin\vim.exe")
  .$vim $args
}

# vi
function vi { vim $args }

# ln
function ln {
  if (($args[0] -eq "-h") -or ($args[0] -eq "--help")) {
    Write-Host "create symbolic link"
    Write-Host "ln -s [link name] [target path]"
    return
  }
  if (!($args[0] -eq "-s")) {
    Write-Host "command is missing (-s)"
    Write-Host "ln -s [link name] [target path]"
    return
  }
  if ($args.Length -lt 3) {
    Write-Host "missing params."
    Write-Host "ln -s [link name] [target path]"
    return
  }

  New-Item -ItemType SymbolicLink -Name $args[1] -Target $args[2]
}

# mklink
function mklink { ln $args }

# unlink
function unlink {
  Param($path)

  if (!(Test-Path $path)) {
    Write-Host "not found"
    return;
  }

  $file = Get-Item $path -Force -ea SilentlyContinue
  if (!($file.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
    $file.Is
    Write-Host "file is not symlink"
    return
  }

  $file.Delete()
}

# export
function export {
  if ($args.Length -eq 0) {
    printenv
    return
  }

  ($key, $value) = $args[0] -split "="
  set-item "env:${key}" $value
}
