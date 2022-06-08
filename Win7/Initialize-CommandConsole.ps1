$ErrorActionPreference = "Stop"

function ConvertTo-ConsoleSize {
    param (
        [Parameter(Mandatory = $true)]
        [int]
        $Width,

        [Parameter(Mandatory = $true)]
        [int]
        $Height
    )

    $high = $Height.ToString("x")
    $low = $Width.ToString("x").PadLeft(4, "0")
    $hex = $high + $low

    return [System.Convert]::ToInt32($hex, 16)
}

# Maximum Value Is 9999
$ConsoleBufferWidth = 80
$ConsoleBufferHeight = 1000
$ConsoleWindowWidth = 80
$ConsoleWindowHeight = 32

$Key = "HKCU:\Console"

Write-Host "Console : Increases console buffer size..."
$ScreenBufferSize = ConvertTo-ConsoleSize -Width $ConsoleBufferWidth -Height $ConsoleBufferHeight
$null = New-ItemProperty -Path $Key -Name ScreenBufferSize -Value $ScreenBufferSize -PropertyType DWord -Force

Write-Host "Console : Increases console window size..."
$WindowSize = ConvertTo-ConsoleSize -Width $ConsoleWindowWidth -Height $ConsoleWindowHeight
$null = New-ItemProperty -Path $Key -Name WindowSize -Value $WindowSize -PropertyType DWord -Force

Write-Host "Console : QuickEdit Mode : Disabled"
$null = New-ItemProperty -Path $Key -Name QuickEdit -Value 0 -PropertyType DWord -Force

Write-Host "Console : Insert Mode : Enabled"
$null = New-ItemProperty -Path $Key -Name InsertMode -Value 1 -PropertyType DWord -Force

Write-Host "Console : Discard Old Duplicates : Enabled"
$null = New-ItemProperty -Path $Key -Name HistoryNoDup -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Console : AutoComplete : Enabled"
$Key = "HKCU:\Software\Microsoft\Command Processor\"
$null = New-ItemProperty -Path $Key -Name CompletionChar -Value 9 -PropertyType DWord -Force
