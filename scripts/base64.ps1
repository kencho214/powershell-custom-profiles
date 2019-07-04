function base64 {
  if ($args[0] -eq "-h" -or $args[0] -eq "--help") {
  }
  if ($args[0] -eq "-d") {
    return decodeBase64 $args[1] $args[2]
  }
  elseif ($args[0].Length -ge 1) {
    return encodeBase64 $args[0] $args[1];
  }

  Write-Host "base64 [filename]"
  Write-Host "base64 [-t|--text] [string]"
  Write-Host "base64 [-d|--decode] [filename]"
  Write-Host "base64 [-d|--decode] [-t|--text] [string]"
}

function encodeBase64 {
  $txt = ""
  if ($args[0] -eq "-t" -or $args[0] -eq "--text") {
    $txt = $args[1]
  }
  else {
    $txt = Get-Content $args[0]
  }

  $bytes = ([System.Text.Encoding]::Default).GetBytes($txt)
  $rtn = [Convert]::ToBase64String($bytes)
  return $rtn
}

function decodeBase64 {
  $txt = ""
  if ($args[0] -eq "-t" -or $args[0] -eq "--text") {
    $txt = $args[1]
  }
  else {
    $txt = Get-Content $args[0]
  }
  
  $bytes = [System.Convert]::FromBase64String($txt)
  $rtn = [System.Text.Encoding]::Default.GetString($bytes)
  return $rtn
}