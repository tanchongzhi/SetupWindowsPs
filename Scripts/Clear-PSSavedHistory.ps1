function Clear-PSSavedHistory {
    param ()

    $m = Get-Module -ErrorAction SilentlyContinue -Name PSReadLine

    if ($m) {
        Remove-Item -ErrorAction SilentlyContinue -Path (Get-PSReadLineOption).HistorySavePath
        [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
    } else {
        $null = [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
        [System.Windows.Forms.SendKeys]::Sendwait('%{F7 2}')
    }

    Clear-History
}

Clear-PSSavedHistory
