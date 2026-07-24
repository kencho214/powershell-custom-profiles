# k8s
Set-Alias k kubectl
function kk { kubectl apply -k . }

# k8s contexts

function kubecon { kubectl config $args }

# requires kubectx.exe on PATH (not distributed via krew on Windows)
# see https://github.com/ahmetb/kubectx
function kubectx { kubectx.exe @args }

# k8s namespaces
# requires kubens.exe on PATH (not distributed via krew on Windows)
# see https://github.com/ahmetb/kubectx
function kubens { kubens.exe @args }

function bxlogin {
  ibmcloud login
  ibmcloud cr login
}
