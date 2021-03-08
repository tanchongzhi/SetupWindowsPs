$ComRegisteredTaskStates = @{
    0 = 'Unknown'
    1 = 'Disabled'
    2 = 'Queued'
    3 = 'Ready'
    4 = 'Running'
}


$ComTaskEnumHidden = 1


function New-ScheduledTaskInfoInternal {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory = $true)]
        $ComRegisteredTask
    )

    if ($null -eq $ComRegisteredTask) {
        $state = ''
    } else {
        $state = $ComRegisteredTaskStates[$ComRegisteredTask.State]
    }

    $name = $ComRegisteredTask.Name
    $path = $ComRegisteredTask.Path.SubString(0, $ComRegisteredTask.Path.Length - $ComRegisteredTask.Name.Length)

    if ($path -and (-not $path.EndsWith('\'))) {
        $path += '\'
    }

    $props = @{ TaskPath = $path; TaskName = $name; State = $state; ComRegisteredTask = $ComRegisteredTask; }

    New-Object -TypeName psobject -Property $props
}


function Get-ScheduledTaskCoreInternel {
    [CmdletBinding()]
    [OutputType([psobject[]])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        $ComTaskFolder,

        [Parameter()]
        [string[]]
        $TaskName,

        [Parameter()]
        [switch]
        $Recurse
    )

    try {
        $comRegisteredTaskCollection = $ComTaskFolder.GetTasks($ComTaskEnumHidden)
    } catch [System.IO.FileNotFoundException] {
        return
    }

    if ($comRegisteredTaskCollection) {
        foreach ($comRegisteredTask in $comRegisteredTaskCollection) {
            if ($TaskName) {
                $TaskName | ForEach-Object -Process {
                    if ($_ -eq $comRegisteredTask.Name) {
                        New-ScheduledTaskInfoInternal -ComRegisteredTask $comRegisteredTask
                    }
                }
            } else {
                New-ScheduledTaskInfoInternal -ComRegisteredTask $comRegisteredTask
            }
        }
    }

    if ($Recurse) {
        try {
            $comTaskFolderCollection = $ComTaskFolder.GetFolders($ComTaskEnumHidden)
        } catch [System.IO.FileNotFoundException] {
            return
        }

        foreach ($childComTaskFolder in $comTaskFolderCollection) {
            Get-ScheduledTaskCoreInternel -ComTaskFolder $childComTaskFolder -TaskName $TaskName -Recurse
        }
    }
}

function Get-ScheduledTaskInternel {
    [CmdletBinding()]
    [OutputType([psobject[]])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        $ComTaskService,

        [Parameter()]
        [string[]]
        $TaskPath,

        [Parameter()]
        [string[]]
        $TaskName
    )

    if ($TaskPath) {
        $TaskPath | ForEach-Object -Process {
            try {
                $comTaskFolder = $ComTaskService.GetFolder($_)
                Get-ScheduledTaskCoreInternel -ComTaskFolder $comTaskFolder -TaskName $TaskName
            } catch [System.IO.FileNotFoundException] {
                return
            }
        }
    } else {
        $comTaskFolder = $ComTaskService.GetFolder('\')

        Get-ScheduledTaskCoreInternel -ComTaskFolder $comTaskFolder -TaskName $TaskName -Recurse
    }
}


$InvalidTaskNameChars = '\/?*<>|'
$InvalidTaskFolderNameChars = '\/?*<>|:"'
$InvalidTaskPathChars = '/?*<>|:"'


function Test-TaskName {
    [CmdletBinding()]
    [OutputType([boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $TaskName
    )

    if (-not $TaskName) {
        return $false
    }

    $TaskName = $TaskName.Trim()

    if (-not $TaskName) {
        return $false
    }

    if ($TaskName.IndexOfAny($InvalidTaskNameChars) -ne -1) {
        return $false
    }

    return $true
}

function Test-TaskPath {
    [CmdletBinding()]
    [OutputType([boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $TaskPath
    )

    $TaskPath = $TaskPath.Trim()

    if ((-not $TaskPath) -or (-not $TaskPath.StartsWith('\')) -or (-not $TaskPath.EndsWith('\')) -or
        ($TaskPath.Contains('\\')) -or ($TaskPath.IndexOf('/') -ne -1)) {
        return $false
    }

    $parts = $TaskPath.Split('\')

    foreach ($name in $parts) {
        if ($name.IndexOfAny($InvalidTaskFolderNameChars) -ne -1) {
            return $false
        }
    }

    return $true
}

function Get-ScheduledTask {
    [CmdletBinding()]
    [OutputType([psobject[]])]
    param (
        [Parameter(Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNull()]
        [string[]]
        $TaskName,

        [Parameter(Position = 1, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNull()]
        [string[]]
        $TaskPath
    )

    begin {
        $comTaskService = New-Object -ComObject Schedule.Service
        $comTaskService.Connect()
    }

    process {
        if ($TaskName) {
            $names = @()

            foreach ($name in $TaskName) {
                if (Test-TaskName -TaskName $name) {
                    $names += $name
                } else {
                    throw "Invalid argument value for parameter -TaskName: $name"
                }
            }

            $TaskName = $names
        }

        if ($TaskPath) {
            $paths = @()

            foreach ($path in $TaskPath) {
                if (Test-TaskPath -TaskPath $path) {
                    if ($path.Length -gt 1) {
                        $paths += $path.TrimEnd('\')
                    } else {
                        $paths += $path
                    }
                } else {
                    throw "Invalid argument value for parameter -TaskPath: $path"
                }
            }

            $TaskPath = $paths
        }

        Get-ScheduledTaskInternel -ComTaskService $comTaskService -TaskPath $TaskPath -TaskName $TaskName
    }
}

function Disable-ScheduledTask {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        $InputObject,

        [Parameter()]
        [string[]]
        $TaskName,

        [Parameter()]
        [string[]]
        $TaskPath
    )

    process {
        if ($InputObject.ComRegisteredTask) {
            $InputObject.ComRegisteredTask.Enabled = $false
            return
        }

        Get-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath | Disable-ScheduledTask
    }
}

Export-ModuleMember -Function Get-ScheduledTask
Export-ModuleMember -Function Disable-ScheduledTask
