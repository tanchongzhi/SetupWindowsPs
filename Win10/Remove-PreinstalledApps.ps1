Get-AppxPackage "Microsoft.549981C3F5F10" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingWeather" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.GetHelp" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.Getstarted" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.Microsoft3DViewer" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftOfficeHub" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftSolitaireCollection" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftStickyNotes" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.MixedReality.Portal" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.MSPaint" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.Office.OneNote" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.People" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.SkypeApp" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.Wallet" -AllUsers | Remove-AppxPackage
#Get-AppxPackage "Microsoft.Windows.Photos" -AllUsers | Remove-AppxPackage
Get-AppxPackage "microsoft.windowscommunicationsapps" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsFeedbackHub" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsMaps" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.Xbox*" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.YourPhone" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.ZuneMusic" -AllUsers | Remove-AppxPackage
Get-AppxPackage "Microsoft.ZuneVideo" -AllUsers | Remove-AppxPackage

Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.549981C3F5F10" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.BingWeather" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.GetHelp" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.Getstarted" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.Microsoft3DViewer" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.MicrosoftOfficeHub" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.MicrosoftSolitaireCollection" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.MicrosoftStickyNotes" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.MixedReality.Portal" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.MSPaint" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.Office.OneNote" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.People" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.SkypeApp" } | Remove-AppxProvisionedPackage -Online -AllUsers
#Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.Windows.Photos" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "microsoft.windowscommunicationsapps" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.WindowsFeedbackHub" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.WindowsMaps" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.Xbox*" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.YourPhone" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.ZuneMusic" } | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -ilike "Microsoft.ZuneVideo" } | Remove-AppxProvisionedPackage -Online -AllUsers
