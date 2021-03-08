function Add-ShellNewSubmenuItem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^\.?[a-zA-Z0-9_-]+$')]
        [string]
        $FileType,

        [Parameter()]
        [ValidateSet('CopyFile', 'Command', 'WriteData', 'NullFile')]
        [string]
        $FileCreationMethod = 'NullFile',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Value,

        [Parameter()]
        [ValidatePattern('[a-zA-Z0-9_.-]{3,}')]
        [string]
        $ProgID,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $FriendlyName
    )

    if ($ShellNewSubmenuPreservedFileTypes -contains $FileType) {
        throw "Unable to edit the preserved file type '$FileType'."
    }
    if (($FileCreationMethod -ne 'NullFile') -and [string]::IsNullOrEmpty($Value)) {
        throw "When -FileCreationMethod is $FileCreationMethod, the parameter -Value is required."
    }

    if (Test-Path -Path "HKCR:\$FileType" -PathType Container) {
        $currentProgID = (Get-ItemProperty -Path "HKCR:\$FileType").'(default)'

        if ([string]::IsNullOrEmpty($currentProgID)) {
            if ([string]::IsNullOrEmpty($ProgID)) {
                throw 'The specified file type has no ProgID, the parameter -ProgID is required.'
            }

            $null = Set-Item -Path "HKCR:\$FileType" -Value $ProgID -Force
        } else {
            if (-not [string]::IsNullOrEmpty($ProgID)) {
                Write-Host "The ProgID of the specified file type '$FileType' has already been set to '$currentProgID'. "
                Write-Host 'The specified parameter -ProgID will be ignored.'
            }

            $ProgID = $currentProgID
        }

        if (Test-Path -Path "HKCR:\$ProgID" -PathType Container) {
            $currentFriendlyName = (Get-ItemProperty -Path "HKCR:\$ProgID").'(default)'

            if ([string]::IsNullOrEmpty($currentFriendlyName)) {
                if ([string]::IsNullOrEmpty($FriendlyName)) {
                    throw 'The specified file type has no friendly name, the parameter -FriendlyName is required.'
                }

                $null = Set-Item -Path "HKCR:\$ProgID" -Value $FriendlyName -Force
            } else {
                if (-not [string]::IsNullOrEmpty($FriendlyName)) {
                    Write-Host "The friendly name of the specified file type '$FileType' has already set to '$currentFriendlyName'."
                    Write-Host 'The specified parameter -FriendlyName will be ignored.'
                }

                $FriendlyName = $currentFriendlyName
            }
        } else {
            if (-not [string]::IsNullOrEmpty($FriendlyName)) {
                throw "The specified file type has no friendly name, the parameter -FriendlyName is required."
            }

            $null = New-Item -Path "HKCR:\$ProgID" -Value $FriendlyName -Force
        }
    } else {
        if (-not ([string]::IsNullOrEmpty($ProgID) -and [string]::IsNullOrEmpty(($FriendlyName)))) {
            throw "The specified file type has no friendly name and ProgID, the parameters -FriendlyName -ProgID are required."
        }

        $null = New-Item -Path "HKCR:\$FileType" -Value $ProgID -Force
        $null = New-Item -Path "HKCR:\$FileType\$ProgID" -Value $FriendlyName -Force
    }

    $shellNewKey = "HKCR:\$FileType\ShellNew"

    if (-not (Test-Path -Path $shellNewKey -PathType Container)) {
        $shellNewKey = "HKCR:\$FileType\$ProgID\ShellNew"
    }

    if (Test-Path -Path $shellNewKey -PathType Container) {
        foreach ($creationMethodName in @('NullFile', 'FileName', 'Data', 'Command')) {
            if ($null -ne (Get-ItemProperty -Path $shellNewKey -Name $creationMethodName -ErrorAction SilentlyContinue)) {
                throw 'The specified file type has already been added.'
            }
        }
    } else {
        $null = New-Item -Path $shellNewKey -Force
    }

    switch ($FileCreationMethod) {
        'NullFile' {
            $null = New-ItemProperty -Path $shellNewKey -Name NullFile -PropertyType String -Force
            break
        }
        'CopyFile' {
            $item = Get-Item -Path $Value -Force
            $null = New-ItemProperty -Path $shellNewKey -Name FileName -Value $item.FullName -PropertyType String -Force
            break
        }
        'WriteData' {
            $dataBytes = [System.Text.Encoding]::UTF8.GetBytes($Value)
            $null = New-ItemProperty -Path $shellNewKey -Name Data -Value $dataBytes -PropertyType Binary -Force
            break
        }
        'Command' {
            $null = New-ItemProperty -Path $shellNewKey -Name Command -Value $Value -PropertyType String -Force
            break
        }
        default {
            break
        }
    }
}
