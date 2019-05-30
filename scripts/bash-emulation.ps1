# Alias
Set-Alias grep Select-String

# Function
function printenv { Get-ChildItem Env: }
function which { (Get-Command $args).Definition }

