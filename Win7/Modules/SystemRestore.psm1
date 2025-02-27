$_SystemRestoreNativeMethodSignatures = @'
[DllImport("Srclient.dll")]
public static extern int SRRemoveRestorePoint (int index);
'@

function Remove-ComputerRestorePoint {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('SequenceNumber')]
        [int[]]
        $RestorePoint
    )

    begin {
        if (-not ('SystemRestoreNativeMethods.RestorePointAPI' -as [type])) {
            $AddTypeParams = @{
                MemberDefinition = $_SystemRestoreNativeMethodSignatures
                Name             = 'RestorePointAPI'
                NameSpace        = 'SystemRestoreNativeMethods'
            }

            Add-Type @AddTypeParams
        }
    }

    process {
        $RestorePoint | ForEach-Object -Process {
            [SystemRestoreNativeMethods.RestorePointAPI]::SRRemoveRestorePoint($_)
        } | Out-Null
    }
}

Export-ModuleMember -Function Remove-ComputerRestorePoint
