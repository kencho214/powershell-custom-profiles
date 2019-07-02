# sudo
function Invoke-CommandRunAs {
  $cd = (Get-Location).Path
  $commands = "Set-Location $cd; Write-Host `"[Administrator] $cd> $args`"; $args; Pause; exit"
  $bytes = [System.Text.Encoding]::Unicode.GetBytes($commands)
  $encodedCommand = [Convert]::ToBase64String($bytes)
  Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit", "-encodedCommand", $encodedCommand
}

Set-Alias sudo Invoke-CommandRunAs

function Start-RunAs {
  $cd = (Get-Location).Path
  $commands = "Set-Location $cd; (Get-Host).UI.RawUI.WindowTitle += `" [Administrator]`""
  $bytes = [System.Text.Encoding]::Unicode.GetBytes($commands)
  $encodedCommand = [Convert]::ToBase64String($bytes)
  Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit", "-encodedCommand", $encodedCommand
}

Set-Alias su Start-RunAs

# grep
Function grep {
  <#
      .SYNOPSIS
          A grep-like tool for PowerShell.
  
      .DESCRIPTION
          This function searches for text patterns in input strings.
          If input is an object, it is converted to a string prior to processing.
          Matched characters are highlighted.
  
      .PARAMETER Pattern
          Specifies the text patterns to find. Type a string or regular expression. 
          If you type a string, use the SimpleMatch parameter.
  
      .PARAMETER BackgroundColor
          Specifies the background color for matches. (Alias: -bc)
          The default value is "Blue".
  
      .PARAMETER CapturegroupColor
          Specifies the foreground color for capture-group matches. (Alias: -cc)
          The default value is "Red".
  
      .PARAMETER ForegroundColor
          Specifies the foreground color for matches. (Alias: -fc)
          The default value is "White".
  
      .PARAMETER Group
          Specifies the name or number of capture group. (Alias: -g)
          The default value is "0".
  
      .PARAMETER IgnoreCase
          Makes matches case-insensitive. By default, matches are case-sensitive. (Alias: -i)
  
      .PARAMETER InputObject
          Specifies the text to be searched. (Alias: -io)
  
      .PARAMETER Passthru
          Outputs all lines, including ones that do not match. (Alias: -p)
  
      .PARAMETER Narrow
          Converts wide characters into narrow ones internally. (Alias: -n)
          Useful when you don't want to distinguish between narrow and wide characters.
  
      .PARAMETER SimpleMatch
          Uses a simple match rather than a regular expression match. (Alias: -s)
  
      .NOTES
          Author:   earthdiver1
          Version:  V1.02
          Licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
  
  #>
  Param(
    [Parameter(Mandatory = $True)][String]$Pattern,
    [Alias("g")][String]$Group = "0",
    [Alias("i")][Switch]$IgnoreCase,
    [Alias("w")][Switch]$Narrow,
    [Alias("n")][Switch]$Number,
    [Alias("p")][Switch]$Passthru,
    [Alias("s")][Switch]$SimpleMatch,
    [Alias("bc")][ConsoleColor]$BackgroundColor = "Blue",
    [Alias("cc")][ConsoleColor]$CapturegroupColor = "Red",
    [Alias("fc")][ConsoleColor]$ForegroundColor = "White",
  
    [Parameter(ValueFromPipeline = $True)][Alias("io")][PSObject]$InputObject
  )
  Begin {
    try {
      if (-not $Pattern) { break }
      if ($Narrow) {
        Add-Type -AssemblyName "Microsoft.VisualBasic"
        $Pattern = [Microsoft.VisualBasic.Strings]::StrConv($Pattern, [Microsoft.VisualBasic.VbStrConv]::Narrow)
      }
      if ($SimpleMatch) { $Pattern = [regex]::Escape($Pattern) }
      if ($IgnoreCase) { $Pattern = "(?i)" + $Pattern }
      if ($Number) {
        $line = 0
        $width = $host.UI.RawUI.BufferSize.Width - 7
      }
      else {
        $width = $host.UI.RawUI.BufferSize.Width - 1
      }
      $Regex = New-Object Text.RegularExpressions.Regex $Pattern, "Compiled"
      $process_block = {
        Process {
          $line++
          $i = 0
          if ($Narrow) { $_ = [Microsoft.VisualBasic.Strings]::StrConv($_, [Microsoft.VisualBasic.VbStrConv]::Narrow) }
          $match = $Regex.Match($_, $i)
          $m = $match.Groups[$Group]
          if (-not $Passthru -and -not $m.Success) { return }
          if ($Number) { Write-Host $("{0,5}:" -F $line) -NoNewline }
          if ($Group -eq "0") {
            while ($m.Success) {
              if ($m.Index -ge $_.Length) { break }
              if ($m.Length -gt 0) {
                Write-Host $_.SubString($i, $m.Index - $i) -NoNewline
                Write-Host $m.Value -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline 
                $i = $m.Index + $m.Length
              }
              else {
                Write-Host $_.SubString($i, $m.Index - $i + 1) -NoNewline
                $i = $m.Index + 1
              }
              $m = $Regex.Match($_, $i).Groups[0]
            }
          }
          else {
            while ($m.Success) {
              if ($m.Index -ge $_.Length) { break }
              $m0 = $match.Groups[0]
              if ($m0.Length -gt 0) {
                Write-Host $_.SubString($i, $m0.Index - $i) -NoNewline
                Write-Host $_.SubString($m0.Index, $m.Index - $m0.Index) `
                  -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
                Write-Host $m.Value -BackgroundColor $BackgroundColor -ForegroundColor $CapturegroupColor -NoNewline 
                $i = $m0.Index + $m0.Length
                $ii = $m.Index + $m.Length
                Write-Host $_.SubString($ii, $i - $ii) `
                  -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
              }
              else {
                Write-Host $_.SubString($i, $m0.Index - $i + 1) -NoNewline
                $i = $m0.Index + 1
              }
              $match = $Regex.Match($_, $i)
              $m = $match.Groups[$Group]
            }
          }
          Write-Host $_.SubString($i)
        }
      }
      $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Out-String', [System.Management.Automation.CommandTypes]::Cmdlet)
      $wrappedCmdParameters = @{ }
      if ($PSBoundParameters.ContainsKey("InputObject")) { $wrappedCmdParameters.Add("InputObject", $InputObject) }
      $wrappedCmdParameters.Add("Stream", $True)
      $wrappedCmdParameters.Add("Width", $width)
      $scriptCmd = { & $wrappedCmd @wrappedCmdParameters | & $process_block }
      $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
      $steppablePipeline.Begin($PSCmdlet)
    }
    catch {
      throw
    }
  }
  Process {
    try {
      $steppablePipeline.Process($_)
    }
    catch {
      throw
    }
  }
  End {
    try {
      $steppablePipeline.End()
      Remove-Variable Regex
    }
    catch {
      throw
    }
  }
}

# curl - unbind predefined alias
Remove-Item alias:curl -Force

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
