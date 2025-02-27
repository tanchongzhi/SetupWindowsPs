$ErrorActionPreference = 'Stop'

$osVersion = [System.Environment]::OSVersion.Version

if (($osVersion.Major -lt 10) -or ($osVersion.Build -lt 18362) -or (-not [System.Environment]::Is64BitOperatingSystem)) {
    Write-Host 'Error: To install or update to WSL 2, you must be running Windows 10... For x64 systems: Version 1903 or later, with Build 18362.1049 or later... or Windows 11.'

    exit 1
}

try {
    wsl --install

    exit 0
} catch {
}

if ($osVersion.Major -eq 10) {
    # https://docs.microsoft.com/en-us/windows/wsl/install-manual

    DISM /Online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /All /NoRestart
    DISM /Online /Enable-Feature /FeatureName:VirtualMachinePlatform /All /NoRestart

    Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile $env:TEMP\wsl_update_x64.msi -UseBasicParsing
    msiexec $env:TEMP\wsl_update_x64.msi /quiet /norestart

    wsl --set-default-version 2
}

wsl --update
