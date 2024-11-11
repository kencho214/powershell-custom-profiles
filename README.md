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

```
# C:\Users\<user>\Documents\WindowsPowerShell\profile.ps1

Import-Module "${Env:PSCustomScripts}\custom-profile.ps1"
```

## Check

Launch new PowerShell terminal, then you will see;

```
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Custom PowerShell Environment Loaded <<<
```

use some sample scripts

```
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

```powershell
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
mklink -s [link name] [target path]

# remove symbolic link
unlink [link name]
```

### open with VSCode using ghq / peco

You need to install peco, golang, ghq before using this command.

```ps
repos
# interructive search
QUERY>  [fuzzy search keyword]                             IgnoreCase [107 (1/4)]
C:\Users\<UserDir>\work\git\github\angular-playground
C:\Users\<UserDir>\work\git\github\electron-playground
...
```

Select disired repo, then VSCode will open with the selected repo.

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

```ps
# abbr. of kubectl config
kubecon

# kuberctl context control

# show contexts
kubectx

# use context
kubectx [context name]

# show name spaces by current context
kubens

# switch name space
kubens [namespace]
```
