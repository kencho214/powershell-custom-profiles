##################
# Variables
##################

Set-Item "Env:hosts" "C:\Windows\System32\drivers\etc\hosts"

##################
# Proxy
##################

function addNoProxy {
  $noProxy = $($Env:NO_PROXY -split "\s*\,\s*")

  $tobeAdded = New-Object System.Collections.ArrayList
  foreach ($elm in ($args)) {
    $tobeAdded += $($($elm -replace "\s+", ",") -split "\s*\,\s*");
  }

  $list = New-Object System.Collections.ArrayList
  foreach ($elm in ($noProxy + $tobeAdded)) {
    if (!$elm) { continue }
    if ($list -contains $elm) { continue }
    if ($list -match "(^\s*$)") { continue }
    $list += $elm
  }

  $list = $list | Sort-Object
  
  userenv "NO_PROXY=$($list -join ',')"
}

function rmNoProxy {
  $noProxy = $($Env:NO_PROXY -split "\s*\,\s*")

  $tobeRemoved = New-Object System.Collections.ArrayList
  foreach ($elm in ($args)) {
    $tobeRemoved += $($($elm -replace "\s+", ",") -split "\s*\,\s*");
  }
  
  $list = New-Object System.Collections.ArrayList
  foreach ($elm in ($noProxy)) {
    if (!$elm) { continue }
    if ($list -contains $elm) { continue }
    if ($tobeRemoved -contains $elm) { continue }
    if ($list -match "(^\s*$)") { continue }
    $list += $elm
  }

  $list = $list | Sort-Object
  
  userenv "NO_PROXY=$($list -join ',')"
}

function printNoProxy {
  Write-Output $($Env:NO_PROXY -split "\s*\,\s*")
}

function noproxy {
  if ($args.Length -eq 0) {
    return printNoProxy
  }
  if ($args[0] -eq "get") {
    return printNoProxy
  }
  if ($args[0] -eq "add") {
    return addNoProxy $args[1..$args.Length]
  }
  if ($args[0] -eq "rm") {
    return rmNoProxy $args[1..$args.Length]
  }

  Write-Host "noproxy [add|rm] [host1,host2,...]"
}

function enableProxy {
  $httpProxy = userenv "__HTTP_PROXY"
  $httpsProxy = userenv "__HTTPS_PROXY"

  userenv "HTTP_PROXY=$httpProxy"
  userenv "HTTPS_PROXY=$httpsProxy"
}

function disableProxy {
  $httpProxy = userenv "HTTP_PROXY"
  $httpsProxy = userenv "HTTPS_PROXY"

  userenv "__HTTP_PROXY=$httpProxy"
  userenv "__HTTPS_PROXY=$httpsProxy"

  rmuserenv "HTTP_PROXY"
  rmuserenv "HTTPS_PROXY"
}


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

function rmuserenv {
  if ($args.Length -eq 0) {
    printenv
    return
  }

  ($key, $value) = $args[0] -split "="

  if ($key -eq "path") {
    Write-Host "path should not overwrite by this command." -ForegroundColor Red
    Write-Host "use addpath/rmpath/getpath instead." -ForegroundColor Yellow
    return
  }

  [System.Environment]::SetEnvironmentVariable($key, "", "User")
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
