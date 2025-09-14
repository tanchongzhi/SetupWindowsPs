$ErrorActionPreference = 'Stop'

$osVersion = [System.Environment]::OSVersion.Version

if (($osVersion.Major -le 6) -and ($osVersion.Minor -le 1)) {
    Write-Host 'System Failure : Write debugging information : Kernel memory dump'
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\CrashControl' -Name CrashDumpEnabled -Value 2 -Type DWord
} else {
    # Windows 8+

    Write-Host 'System Failure : Write debugging information : Automatic memory dump'
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\CrashControl' -Name CrashDumpEnabled -Value 7 -Type DWord
}

Write-Host 'System Failure : Write an event to the system log : Enabled'
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\CrashControl' -Name LogEvent -Value 1 -Type DWord

Write-Host 'System Failure : Memory dump file : %SystemRoot%\MEMORY.DMP'
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\CrashControl' -Name DumpFile -Value '%SystemRoot%\MEMORY.DMP' -Type ExpandString

Write-Host 'System Failure : Small memory dump directory : %SystemRoot%\Minidump'
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\CrashControl' -Name MinidumpDir -Value '%SystemRoot%\Minidump' -Type ExpandString

Write-Host 'System Failure : Small memory dump count : 5'
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\CrashControl' -Name MinidumpsCount -Value 5 -Type DWord

Write-Host 'System Failure : Overwrite old memory dump : Enabled'
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\CrashControl' -Name Overwrite -Value 1 -Type DWord

Write-Host 'System Failure : Automatically restart : Enabled'
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\CrashControl' -Name AutoReboot -Value 1 -Type DWord
