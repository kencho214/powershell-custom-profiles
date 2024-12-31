# set dir name to load custom scripts automatically
# PSCustomScripts must be defined as a environment variable

#---------------------------------------------------------------------------
# install posh-git, posh-sshell;
#   PowerShellGet\Install-Module posh-sshell -Scope CurrentUser -Force
#   PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force
#---------------------------------------------------------------------------

Import-Module posh-sshell
Import-Module posh-git

if ($GitPromptSettings) {
  $GitPromptSettings.DefaultPromptPrefix.Text = '[$(Get-Date -f "MM-dd HH:mm:ss")] '
  $GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [ConsoleColor]::Green
  $GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
  # $GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'
  $GitPromptSettings.DefaultPromptSuffix.Text = ' $ '
}

# pwsh (Powershell 7)
# winget install --id Microsoft.PowerShell --source winget

# windows build tools
# winget install Microsoft.VisualStudio.2022.BuildTools

# Load custom scripts
Get-ChildItem $Env:PSCustomScripts\scripts | Where-Object Extension -eq ".ps1" | ForEach-Object { .$_.FullName }

Write-Host "Custom PowerShell Environment Loaded" -ForegroundColor DarkGray
