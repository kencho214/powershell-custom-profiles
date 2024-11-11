# winget install peco
# winget install golang
# go install github.com/x-motemen/ghq@latest

function repos {
  code $(ghq list -p | peco) --disable-extensions
}
