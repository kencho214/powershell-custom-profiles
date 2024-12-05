# winget install peco
# winget install golang
# winget install vscode
# go install github.com/x-motemen/ghq@latest

function Repos {
  $repo_path = $(ghq list -p | peco)

  if ($repo_path.Length -ge 1) {
    code $repo_path --disable-extensions
  }
}

function ReposRemote {
  $repoList = gh repo list $args[0] --json name,url --limit 1000 | ConvertFrom-Json

  $selected = $repoList.name | peco

  if ($selected.Length -le 0) {
    return
  }

  $localPath = ghq list -p -e $selected

  if ($localPath.Length -ge 1) {
    code $localPath --disable-extensions
    return
  }

  $repoUrl = $($repoList | Where-Object name -eq $selected).url

  Write-Output $repoUrl

  $ghqRoots = $(ghq root --all)
  $ghqRoot = $ghqRoots.GetType().Name -eq "String" ? $ghqRoots : ($ghqRoots | peco)

  if ($ghqRoot -le 0) {
    return
  }

  git clone $repoUrl "$ghqRoot\$selected"
  code $(ghq list -p -e $selected) --disable-extensions
}

function SshHosts {
  $sshConfig = Get-Content "~\.ssh\**\config"
  $sshHosts = $sshConfig -cmatch "Host "
  $hosts = $sshHosts -replace "Host ", ""
  Write-Output $hosts
}

function SshRemote {
  $selected = SshHosts | peco

  if ($selected.Length -le 0) {
    return
  }

  Write-Host "ssh $selected"
  ssh $selected
}
