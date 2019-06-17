##################
# Variables
##################

Set-Item "Env:hosts" "C:\Windows\System32\drivers\etc\hosts"

##################
# Functions
##################

function userenv {
  if ($args.Length -eq 0) {
    printenv
    return
  }

  ($key, $value) = $args[0] -split "="

  if (!$value) {
    [System.Environment]::GetEnvironmentVariable($args[0])
    return
  }

  if ($key -eq "path") {
    Write-Host "path should not overwrite by this command." -ForegroundColor Red
    Write-Host "use addpath/rmpath/getpath instead." -ForegroundColor Yellow
    return
  }

  Set-Item "env:${key}" $value
  [System.Environment]::SetEnvironmentVariable($key, $value, "User")
}

function getpath {
  $paths = $([System.Environment]::GetEnvironmentVariable("path", "User")) -split ";"

  foreach ($arg in $paths) {
    Write-Host $arg
  }
}

function addpath {
  $paths = $([System.Environment]::GetEnvironmentVariable("path", "User")) -split ";"

  if ($args.Length -eq 0) {
    Write-Error "addpath [path1] [path2] ..."
    return
  }

  $list = New-Object System.Collections.ArrayList

  foreach ($elm in ($paths + $args)) {
    if (!$elm) { continue }
    if ($list -contains $elm) { continue }
    $list += $elm
  }

  foreach ($elm in $list) { Write-Host $elm }

  $tmpPath = $list -join ";"

  Set-Item "env:path" $tmpPath
  [System.Environment]::SetEnvironmentVariable("path", $tmpPath, "User")
}

function rmpath {
  $paths = $([System.Environment]::GetEnvironmentVariable("path", "User")) -split ";"

  if ($args.Length -eq 0) {
    Write-Error "rmpath [path1] [path2] ..."
    return
  }

  $list = New-Object System.Collections.ArrayList

  foreach ($elm in $paths) {
    if (!$elm) { continue }
    if ($args -contains $elm) { continue }
    $list += $elm
  }

  foreach ($elm in $list) { Write-Host $elm }

  $tmpPath = $list -join ";"

  Set-Item "env:path" $tmpPath
  [System.Environment]::SetEnvironmentVariable("path", $tmpPath, "User")
}
