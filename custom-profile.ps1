# set dir name to load custom scripts automatically
# PSCustomScripts must be defined as a environment variable
Get-ChildItem $Env:PSCustomScripts\scripts | Where-Object Extension -eq ".ps1" | ForEach-Object{.$_.FullName}

function prompt {
  $origLastExitCode = $LASTEXITCODE
  $prompt = Write-Host ($ExecutionContext.SessionState.Path.CurrentLocation) -ForegroundColor Green -nonewline
  $prompt += Write-VcsStatus
  $LASTEXITCODE = $origLastExitCode
  $prompt += "$(' $' * ($nestedPromptLevel + 1))"
  if ($prompt) { "$prompt " } else { " " }
}

Write-Host "Custom PowerShell Environment Loaded" -ForegroundColor DarkGray