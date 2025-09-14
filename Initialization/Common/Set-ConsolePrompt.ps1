$ErrorActionPreference = 'Stop'

function ConvertTo-ConsoleSize {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ -le 9999 })]
        [int]
        $Width,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ -le 9999 })]
        [int]
        $Height
    )

    $high = $Height.ToString('x')
    $low = $Width.ToString('x').PadLeft(4, '0')
    $hex = $high + $low

    return [System.Convert]::ToInt32($hex, 16)
}

# The maximum value is 9999
$consoleBufferWidth = 120
$consoleBufferHeight = 9001
$consoleWindowWidth = 120
$consoleWindowHeight = 30

#-------------------------------------------------------------------------------

Write-Host 'Console : Increases console buffer size...'
$screenBufferSize = ConvertTo-ConsoleSize -Width $consoleBufferWidth -Height $consoleBufferHeight
Set-ItemProperty -Path 'HKCU:\Console' -Name ScreenBufferSize -Value $screenBufferSize -Type DWord

Write-Host 'Console : Increases console window size...'
$windowSize = ConvertTo-ConsoleSize -Width $consoleWindowWidth -Height $consoleWindowHeight
Set-ItemProperty -Path 'HKCU:\Console' -Name WindowSize -Value $windowSize -Type DWord

Write-Host 'Console : QuickEdit Mode : Enabled'
Set-ItemProperty -Path 'HKCU:\Console' -Name QuickEdit -Value 1 -Type DWord

Write-Host 'Console : Insert Mode : Enabled'
Set-ItemProperty -Path 'HKCU:\Console' -Name InsertMode -Value 1 -Type DWord

Write-Host 'Console : Setting up command history buffer size : Disabled'
Set-ItemProperty -Path 'HKCU:\Console' -Name HistoryBufferSize -Value 50 -Type DWord
Set-ItemProperty -Path 'HKCU:\Console' -Name NumberOfHistoryBuffers -Value 4 -Type DWord

Write-Host 'Console : Discard old command history duplicates : Disabled'
Set-ItemProperty -Path 'HKCU:\Console' -Name HistoryNoDup -Value 0 -Type DWord

$osVersion = [System.Environment]::OSVersion.Version

if ($osVersion.Major -le 6) {
    Write-Host 'Console : Allow the use of extended edit keys : Disabled'
    Set-ItemProperty -Path 'HKCU:\Console' -Name ExtendedEditKey -Value 0 -Type DWord
    Set-ItemProperty -Path 'HKCU:\Console' -Name ExtendedEditKeyCustom -Value 0 -Type DWord
} else {
    Write-Host 'Console : Allow the use of extended edit keys : Enabled'
    Set-ItemProperty -Path 'HKCU:\Console' -Name ExtendedEditKey -Value 1 -Type DWord
    Set-ItemProperty -Path 'HKCU:\Console' -Name ExtendedEditKeyCustom -Value 0 -Type DWord
}

if ($osVersion.Major -le 6) {
    Write-Host 'Console : AutoComplete : Enabled'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Command Processor' -Name CompletionChar -Value 9 -Type DWord
}
