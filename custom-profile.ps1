# set dir name to load custom scripts automatically
# PSCustomScripts must be defined as a environment variable
Get-ChildItem $Env:PSCustomScripts\scripts | Where-Object Extension -eq ".ps1" | ForEach-Object{.$_.FullName}

Write-Host "Custom PowerShell Environment Loaded" -ForegroundColor Cyan