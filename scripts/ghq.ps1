# choco install peco
# choco install golang
# go get github.com/motemen/ghq

function gitr {
  ghq look $(ghq list | peco)
}
