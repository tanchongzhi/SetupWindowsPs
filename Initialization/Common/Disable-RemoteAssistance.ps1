$ErrorActionPreference = 'Stop'

Write-Host 'Remote Assistance : Disabled'
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Remote Assistance' -Name fAllowToGetHelp -Value 0 -Type DWord

#-------------------------------------------------------------------------------

Write-Host 'Scheduled Tasks : \Microsoft\Windows\RemoteAssistance\* : Disabled'
schtasks /Change /Disable /TN '\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask'
