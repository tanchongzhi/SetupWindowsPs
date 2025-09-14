$ErrorActionPreference = 'SilentlyContinue'

Write-Host 'Removing Cortana...'
Get-AppxPackage 'Microsoft.549981C3F5F10' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'Microsoft.549981C3F5F10' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

Write-Host 'Removing Get Help...'
Get-AppxPackage 'Microsoft.GetHelp' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'Microsoft.GetHelp' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

Write-Host 'Removing Get started...'
Get-AppxPackage 'Microsoft.Getstarted' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'Microsoft.Getstarted' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

Write-Host 'Removing 3D Viewer...'
Get-AppxPackage 'Microsoft.Microsoft3DViewer' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'Microsoft.Microsoft3DViewer' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

Write-Host 'Removing Paint 3D...'
Get-AppxPackage 'Microsoft.MSPaint' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'Microsoft.MSPaint' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

Write-Host 'Removing Mixed Reality Portal...'
Get-AppxPackage 'Microsoft.MixedReality.Portal' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'Microsoft.MixedReality.Portal' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

Write-Host 'Removing Sticky Notes...'
Get-AppxPackage 'Microsoft.MicrosoftStickyNotes' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'Microsoft.MicrosoftStickyNotes' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

Write-Host 'Removing Windows Maps...'
Get-AppxPackage 'Microsoft.WindowsMaps' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'Microsoft.WindowsMaps' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

Write-Host 'Removing People...'
Get-AppxPackage 'Microsoft.People' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'Microsoft.People' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

Write-Host 'Removing Windows Communications Apps (People, Mail, and Calendar)...'
Get-AppxPackage 'microsoft.windowscommunicationsapps' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'microsoft.windowscommunicationsapps' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

Write-Host 'Removing Wallet...'
Get-AppxPackage 'Microsoft.Wallet' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'Microsoft.Wallet' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

Write-Host 'Removing Groove Music...'
Get-AppxPackage 'Microsoft.ZuneMusic' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'Microsoft.ZuneMusic' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

Write-Host 'Removing Films & TV...'
Get-AppxPackage 'Microsoft.ZuneVideo' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'Microsoft.ZuneVideo' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

Write-Host 'Removing Solitaire Collection...'
Get-AppxPackage 'Microsoft.MicrosoftSolitaireCollection' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'Microsoft.MicrosoftSolitaireCollection' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

Write-Host 'Removing Skype...'
Get-AppxPackage 'Microsoft.SkypeApp' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'Microsoft.SkypeApp' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

Write-Host 'Removing Office Hub...'
Get-AppxPackage 'Microsoft.MicrosoftOfficeHub' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'Microsoft.MicrosoftOfficeHub' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

Write-Host 'Removing OneNote...'
Get-AppxPackage 'Microsoft.Office.OneNote' -AllUsers | Remove-AppxPackage | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript { $_.DisplayName -ilike 'Microsoft.Office.OneNote' } | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null
