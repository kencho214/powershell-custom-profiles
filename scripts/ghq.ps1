# winget install peco
# winget install golang
# go install github.com/x-motemen/ghq@latest

function repos {
  $repo_path = $(ghq list -p | peco)

  if ($repo_path.Length -ge 1) {
    code $repo_path --disable-extensions
  }
}
