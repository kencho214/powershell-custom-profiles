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
