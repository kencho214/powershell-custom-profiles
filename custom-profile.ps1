# set dir name to load custom scripts automatically
# PSCustomScripts must be defined as a environment variable
Get-ChildItem $Env:PSCustomScripts\scripts | Where-Object Extension -eq ".ps1" | ForEach-Object{.$_.FullName}

function prompt {
  $origLastExitCode = $LASTEXITCODE
  $dirs = $ExecutionContext.SessionState.Path.CurrentLocation -split "\\"
  $pwd = $dirs[0]
  if ($dirs.Length -gt 2) {
    $intermediates += $dirs[1..($dirs.Length - 2)] | ForEach-Object { $_.Substring(0, 1) }
    $pwd += "\"
    $pwd += $intermediates -join "\"
  }
  if ($dirs.Length -gt 1) {
    $pwd += "\" + $dirs[-1]
  }  
   
  # Write-Host ($ExecutionContext.SessionState.Path.CurrentLocation) -ForegroundColor Green -nonewline
  Write-Host ($pwd) -ForegroundColor Green -nonewline
  Write-VcsStatus
  # Write-Host
  $LASTEXITCODE = $origLastExitCode
  "$(' $' * ($nestedPromptLevel + 1)) "
}

Write-Host "Custom PowerShell Environment Loaded" -ForegroundColor DarkGray