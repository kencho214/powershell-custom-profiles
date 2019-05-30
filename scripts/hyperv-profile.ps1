function enable-hyperv {
  bcdedit /set hypervisorlaunchtype auto
  Write-Host "To reflect this change, you need to reboot the system" -ForegroundColor Yellow
}

function disable-hyperv {
  bcdedit /set hypervisorlaunchtype off
  Write-Host "To reflect this change, you need to reboot the system" -ForegroundColor Yellow
}
