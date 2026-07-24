function base64 {
  if ($args.Count -eq 0 -or $args[0] -eq "-h" -or $args[0] -eq "--help") {
    Write-Base64Usage
    return
  }

  if ($args[0] -eq "-d" -or $args[0] -eq "--decode") {
    return decodeBase64 $args[1] $args[2]
  }

  return encodeBase64 $args[0] $args[1]
}

function Write-Base64Usage {
  Write-Host "base64 [filename]"
  Write-Host "base64 [-t|--text] [string]"
  Write-Host "base64 [-d|--decode] [filename]"
  Write-Host "base64 [-d|--decode] [-t|--text] [string]"
}

function encodeBase64 {
  if ($args[0] -eq "-t" -or $args[0] -eq "--text") {
    $bytes = ([System.Text.Encoding]::Default).GetBytes($args[1])
  }
  else {
    if (-not (Test-Path -LiteralPath $args[0] -PathType Leaf)) {
      Write-Error "File not found: $($args[0])"
      return
    }
    if ($PSVersionTable.PSEdition -eq "Core") {
      $bytes = Get-Content -LiteralPath $args[0] -AsByteStream
    }
    else {
      $bytes = Get-Content -LiteralPath $args[0] -Encoding Byte
    }
  }

  return [Convert]::ToBase64String($bytes)
}

function decodeBase64 {
  if ($args[0] -eq "-t" -or $args[0] -eq "--text") {
    $txt = $args[1]
  }
  else {
    if (-not (Test-Path -LiteralPath $args[0] -PathType Leaf)) {
      Write-Error "File not found: $($args[0])"
      return
    }
    # strip whitespace/newlines in case the file wraps base64 across lines
    $txt = (Get-Content -LiteralPath $args[0] -Raw) -replace '\s', ''
  }

  $bytes = [System.Convert]::FromBase64String($txt)
  return [System.Text.Encoding]::Default.GetString($bytes)
}
