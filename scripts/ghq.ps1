# winget install --id peco.peco --source winget
# winget install --id GoLang.Go --source winget
# winget install --id GitHub.cli --source winget
# winget install --id Microsoft.VisualStudioCode --source winget
# go install github.com/x-motemen/ghq@latest

$editor = "code"
# $editor = "antigravity"

function CdRepo {
  $repo_path = $(ghq list -p | peco)

  if ($repo_path.Length -ge 1) {
    cd $repo_path
  }
}

function Repos {
  $repo_path = $(ghq list -p | peco)

  if ($repo_path.Length -ge 1) {
    & $editor $repo_path
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
    & $editor $localPath
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
  & $editor $(ghq list -p -e $selected)
}

function ReposUpdate {
  $env:GIT_TERMINAL_PROMPT = "0"

  foreach ($repo in $(ghq list -p)) {
    if (-not (git -C $repo remote get-url origin 2>$null)) {
      continue
    }

    Write-Output "### $repo"

    if ($(git -C $repo status --porcelain)) {
      git -C $repo fetch origin --prune -q
      Write-Output "  skip: uncommitted changes"
      continue
    }

    git -C $repo fetch origin --prune -q

    $target = $null
    foreach ($b in "develop", "main", "master") {
      git -C $repo show-ref --verify --quiet "refs/remotes/origin/$b"
      if ($LASTEXITCODE -eq 0) {
        $target = $b
        break
      }
    }

    if (-not $target) {
      Write-Output "  skip: no develop/main/master on origin"
      continue
    }

    git -C $repo show-ref --verify --quiet "refs/heads/$target"
    if ($LASTEXITCODE -eq 0) {
      git -C $repo checkout -q $target
    } else {
      git -C $repo checkout -q -t "origin/$target"
    }

    git -C $repo merge --ff-only "origin/$target"

    if (Test-Path "$repo\.gitmodules") {
      git -C $repo submodule update
    }

    Write-Output "  -> $(git -C $repo branch --show-current)"
  }
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

