$_User32APINativeMethodSignatures = @"
    [DllImport("User32.dll", EntryPoint = "SendMessageTimeoutW", SetLastError = true, CharSet = CharSet.Unicode)]
    public static extern IntPtr SendMessageTimeout(IntPtr hWnd, int msg, IntPtr wParam, string lParam, int flags, int timeout, IntPtr pdwResult);
"@

function Send-EnvironmentChangeMessage {
    <#
    .SYNOPSIS
    Send a Windows Environment Change message.
    #>
    [CmdletBinding()]
    param ()
    begin {
        if (-not ("NativeMethods.User32API" -as [type])) {
            $AddTypeParameters = @{
                MemberDefinition = $_User32APINativeMethodSignatures
                Name             = "User32API"
                NameSpace        = "NativeMethods"
            }
            Add-Type @AddTypeParameters
        }
    }
    process {
        $HWND_BROADCAST = [IntPtr]0xFFFF
        $WM_WININICHANGE = 0x001A
        $WM_SETTINGCHANGE = $WM_WININICHANGE
        $SMTO_ABORTIFHUNG = 0x002

        $DefaultTimeout = 300  # in milliseconds.
        $null = [NativeMethods.User32API]::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE, [IntPtr]::Zero, "Environment", $SMTO_ABORTIFHUNG, $DefaultTimeout, [IntPtr]::Zero)
    }
}
