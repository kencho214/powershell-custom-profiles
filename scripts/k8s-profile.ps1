# k8s
Set-Alias k kubectl
function kk { kubectl apply -k . }

# k8s contexts

function kubecon { kubectl config $args }

function kubectx { 
  Param($ctx)
  if ($ctx -eq "help") {
    Write-Host "provides simple commands for kubectl config xxxx-context(s)"
    Write-Host ""
    Write-Host "Sample:"
    Write-Host "  kubectx"
    Write-Host "    - shorthand for 'kubectl config get-contexts'"
    Write-Host "  kubectx [context]"
    Write-Host "  kubectx -ctx [context]"
    Write-Host "    - shorthand for 'kubectl config use-context [context]'"
    return;
  }

  if (!$ctx) {
    kubectl config get-contexts
    return
  }
  if ($ctx) {
    kubectl config use-context $ctx
    kubectl config get-contexts
    return
  }
}

# k8s namespaces
function kubens {
  Param($ns)

  if (!$ns) {
    kubectl get ns
    return
  }
  
  Write-Host set-context $(kubectl config current-context) --namespace=$ns
  kubectl config set-context $(kubectl config current-context) --namespace=$ns
  kubectl config get-contexts
}

# function kubectx-use { kubectl config use-context $args }

# function kubectx-get { kubectl config get-contexts $args }

# function kubectx-rm { kubectl config delete-context $args }

# function kubectx-delete { kubectl config delete-context $args }

# function kubectx-current { kubectl config current-context $args }

# function kubectx-rename { kubectl config rename-context $args }

# function kubectx-set { kubectl config set-context $args }
