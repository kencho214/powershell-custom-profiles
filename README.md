# PowerShell costom profile loading simply

## Setup

Checkout this project to somewhere.

```
(ex.) %USERPROFILE%\Documents\WindowsPowerShell\CustomScripts
```

Add environment variables

```
PSCustomScripts = <Fullpath for project root>

(ex.) %USERPROFILE%\Documents\WindowsPowerShell\CustomScripts
```

Import custom-profile.ps1 from your profile.ps1

```ps
# C:\Users\<user>\Documents\WindowsPowerShell\profile.ps1

Import-Module "${Env:PSCustomScripts}\custom-profile.ps1"
```

## Check

Launch new PowerShell terminal, then you will see;

```ps
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Custom PowerShell Environment Loaded <<<
```

use some sample scripts

```ps
# alias of Get-Command
$ which notepad
> C:\WINDOWS\system32\notepad.exe

# fuction as an alias of "Get-ChildItem Env:"
$ printenv
> ChocolateyToolsLocation        C:\tools
> CommonProgramFiles             C:\Program Files\Common Files
> CommonProgramFiles(x86)        C:\Program Files (x86)\Common Files
> CommonProgramW6432             C:\Program Files\Common Files
...
```

## Add new custom scripts

Create new `.ps1` file in `scripts` directory. `scripts` directory is loaded automatically by `custom-profile.ps1`

## APIs

### base64

```ps
# encode file
base64 [filename]

# encode text
base64 [-t|--text] [string]

# decode base64 text file
base64 [-d|--decode] [filename]

# decode base64 text
base64 [-d|--decode] [-t|--text] [string]
```

### sudo

```ps
# open new powershell as admin
su

# exec command as admin
sudo [command ...]
```

### pwd

```ps
# get current location as full path
pwd
```

### env

```ps
# print environment variables of current session
printenv

# print environment variables of current session
export

# set environment variable of current session
export [key]=[value]
```

### user env

```ps
# print environment variables of current user
userenv

# print environment variable of current user
userenv [key]

# set environment variable of current user
userenv [key]=[value]

# print NO_PROXY with line feed
printNoProxy

# add NO_PROXY values to user env
addNoProxy [ip-or-host],[ip-or-host...]
addNoProxy [ip-or-host] [ip-or-host...]

# remove NO_PROXY values from user env
rmNoProxy [ip-or-host],[ip-or-host...]
rmNoProxy [ip-or-host] [ip-or-host...]

# NO_PROXY control
noproxy [get|add|rm] [ip-or-host],[ip-or-host...]
noproxy [get|add|rm] [ip-or-host] [ip-or-host...]

# get PATH with line feed
getpath

# add PATH(s) to current user env
addpath [path1] [path2] ...

# remove PATH(s) from current user env
rmpath [path1] [path2] ...
```

### file control

```ps
# create file
touch [file name]

# launch git vim
vi
vim

# find command and print path or alias
which [command name]

# find command and print parent dir path
where [command name]

# make symbolic link
ln -s [link name] [target path]

# remove symbolic link
unlink [link name]
```

### open with VSCode using ghq / peco

You need to install peco, golang, ghq before using this command.

#### Install ghq / peco

`winget install --id x-motemen.ghq` / `winget install --id peco.peco` are
listed as `portable (zip)` packages, but on this machine the install
consistently fails at winget's internal symlink-creation step
(`create_symlink: The system cannot find the file specified.`) even from a
clean state. A raw `CreateSymbolicLink` call with the same paths works fine
outside of winget, so the failure is specific to winget's own process, not
Windows or PowerShell. Until that's resolved, install manually the same way
as `kubectx`/`kubens` below.

```ps
# ghq
Invoke-WebRequest -Uri "https://github.com/x-motemen/ghq/releases/download/v1.10.1/ghq_windows_amd64.zip" -OutFile "$Env:TEMP\ghq.zip"
New-Item -ItemType Directory -Force -Path "$Env:USERPROFILE\tools\ghq" | Out-Null
Expand-Archive -Path "$Env:TEMP\ghq.zip" -DestinationPath "$Env:USERPROFILE\tools\ghq" -Force
Remove-Item "$Env:TEMP\ghq.zip"

# peco
Invoke-WebRequest -Uri "https://github.com/peco/peco/releases/download/v0.6.0/peco_0.6.0_windows_amd64.zip" -OutFile "$Env:TEMP\peco.zip"
New-Item -ItemType Directory -Force -Path "$Env:USERPROFILE\tools\peco" | Out-Null
Expand-Archive -Path "$Env:TEMP\peco.zip" -DestinationPath "$Env:USERPROFILE\tools\peco" -Force
Remove-Item "$Env:TEMP\peco.zip"

# confirm where each .exe actually landed before symlinking - the zip layout
# differs per tool/version (e.g. ghq nests it under a versioned subfolder,
# peco does not), so don't assume a fixed path
Get-ChildItem "$Env:USERPROFILE\tools\ghq" -Recurse -Filter "ghq.exe"
Get-ChildItem "$Env:USERPROFILE\tools\peco" -Recurse -Filter "peco.exe"

# symlink the actual exe paths (adjust to match the Get-ChildItem output above) into a PATH directory
New-Item -ItemType Directory -Force -Path "$Env:USERPROFILE\bin" | Out-Null
ln -s "$Env:USERPROFILE\bin\ghq.exe" "$Env:USERPROFILE\tools\ghq\ghq_windows_amd64\ghq.exe"
ln -s "$Env:USERPROFILE\bin\peco.exe" "$Env:USERPROFILE\tools\peco\peco.exe"

# make sure that PATH directory is on PATH (persists to user env, open a new terminal after this)
addpath "$Env:USERPROFILE\bin"
```

Verify the SHA256 against the hash winget shows (`winget show --id x-motemen.ghq` /
`winget show --id peco.peco`) before trusting a downloaded binary, since it
isn't installed through a package manager here.

```ps
Repos
# interructive search
QUERY>  [fuzzy search keyword]                             IgnoreCase [107 (1/4)]
C:\Users\<UserDir>\work\git\github\angular-playground
C:\Users\<UserDir>\work\git\github\electron-playground
...
```

```ps
ReposRemote <owner-or-org>

# interructive search for repos
QUERY>  [fuzzy search keyword]                             IgnoreCase [107 (1/4)]
angular-playground
electron-playground
...

# there is the local repo, open it with VSCode then finish. If not, clone repo from remote.

https://github.com/<owner-or-org>/<selected-repo>

# interructive search for ghq root dirs. If there are multiple roots, you need to select one.
QUERY>  [fuzzy search keyword]                             IgnoreCase [2 (1/1)]
C:\users\<user>\ghq\repos
<user-defined-ghq-root>
...

# Clone repo
```

VSCode will open with the repo accordingly.

### something like grep

```ps
somecommand [args...] | grep [key]
```

### Hyper-V

```ps
# only enable hyper-v, need reboot your computer
enable-hyperv

# only disable hyper-v, need reboot your computer
disable-hyperv
```

### Kubernetes

`kubectx`/`kubens` here are thin wrappers around the real
[ahmetb/kubectx](https://github.com/ahmetb/kubectx) binaries. That project is
**not** distributed via krew on Windows (the krew plugin only targets
`darwin`/`linux`), so install the Windows release binaries directly instead
of via `kubectl krew install ctx`/`ns`.

#### Install

```ps
$version = "v0.11.0" # check https://github.com/ahmetb/kubectx/releases for the latest

foreach ($name in "kubectx", "kubens") {
  $zip = "$Env:TEMP\$name.zip"
  $dest = "$Env:USERPROFILE\tools\$name\$version"

  Invoke-WebRequest -Uri "https://github.com/ahmetb/kubectx/releases/download/$version/${name}_${version}_windows_x86_64.zip" -OutFile $zip
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  Expand-Archive -Path $zip -DestinationPath $dest -Force
  Remove-Item $zip
}

# symlink the current version into a PATH directory
New-Item -ItemType Directory -Force -Path "$Env:USERPROFILE\bin" | Out-Null
ln -s "$Env:USERPROFILE\bin\kubectx.exe" "$Env:USERPROFILE\tools\kubectx\$version\kubectx.exe"
ln -s "$Env:USERPROFILE\bin\kubens.exe" "$Env:USERPROFILE\tools\kubens\$version\kubens.exe"

# make sure that PATH directory is on PATH (persists to user env, open a new terminal after this)
addpath "$Env:USERPROFILE\bin"
```

Verify the checksum against `checksums.txt` on the
[releases page](https://github.com/ahmetb/kubectx/releases) before trusting a
downloaded binary, since it isn't installed through a package manager.

To upgrade later, bump `$version`, re-run the download/extract steps into the
new version folder, then repoint the symlink — no changes needed elsewhere:

```ps
Remove-Item "$Env:USERPROFILE\bin\kubectx.exe", "$Env:USERPROFILE\bin\kubens.exe" -Force
ln -s "$Env:USERPROFILE\bin\kubectx.exe" "$Env:USERPROFILE\tools\kubectx\$newVersion\kubectx.exe"
ln -s "$Env:USERPROFILE\bin\kubens.exe" "$Env:USERPROFILE\tools\kubens\$newVersion\kubens.exe"
```

```ps
# abbr. of kubectl config
kubecon

# kubectl context control (wraps kubectx.exe, see https://github.com/ahmetb/kubectx)

# show contexts
kubectx

# use context
kubectx [context name]

# switch to the previous context
kubectx -

# kubectl namespace control (wraps kubens.exe, see https://github.com/ahmetb/kubectx)

# show name spaces by current context
kubens

# switch name space
kubens [namespace]

# switch to the previous namespace
kubens -
```
