param (
    [Parameter(ParameterSetName = 'ForceInstall')]
    [switch]
    $Force,

    [Parameter(Mandatory = $true, ParameterSetName = 'Uninstall')]
    [switch]
    $Uninstall,

    [Parameter(Mandatory = $true, ParameterSetName = 'Repair')]
    [switch]
    $Repair
)

$ErrorActionPreference = 'Stop'

$SshdConfig = @'
# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.
#

ListenAddress 0.0.0.0

Port 22

HostKey __PROGRAMDATA__/ssh/ssh_host_ed25519_key
HostKey __PROGRAMDATA__/ssh/ssh_host_rsa_key
HostKey __PROGRAMDATA__/ssh/ssh_host_ecdsa_key

Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com

RekeyLimit 1G 1H

StrictModes yes

AuthenticationMethods any
PubkeyAuthentication yes
PasswordAuthentication yes
PermitEmptyPasswords no
PermitRootLogin no

ChallengeResponseAuthentication no
GSSAPIAuthentication no
HostbasedAuthentication no
IgnoreRhosts yes
IgnoreUserKnownHosts no

AuthorizedKeysFile .ssh/authorized_keys

LoginGraceTime 30
MaxStartups 4:50:4
MaxAuthTries 3
MaxSessions 8

TCPKeepAlive no
ClientAliveCountMax 0
ClientAliveInterval 300

FingerprintHash sha256
ExposeAuthInfo no

SyslogFacility AUTH
LogLevel VERBOSE

#SyslogFacility LOCAL0
#LogLevel DEBUG3

PrintLastLog no
PrintMotd no

AllowStreamLocalForwarding yes
AllowAgentForwarding yes
AllowTcpForwarding yes

PermitOpen any
PermitTunnel no
GatewayPorts no

PermitUserEnvironment no

UseDNS no
Compression no
ChrootDirectory none

PermitTTY yes
VersionAddendum none

Subsystem sftp sftp-server.exe

#Subsystem sftp sftp-server.exe-f LOCAL0 -l DEBUG3

Match Group administrators
    AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys

'@

$OpenSSHArchiveNameStem = if ("${env:ProgramFiles(x86)}") {
    'OpenSSH-Win64'
} else {
    'OpenSSH-Win32'
}
$OpenSSHArchiveFullName = "$OpenSSHArchiveNameStem.zip"

$OpenSSHInstallRoot = "${env:ProgramFiles}\OpenSSH"
$OpenSSHReleaseFile = "$OpenSSHInstallRoot\RELEASE.txt"

$env:Path = "$OpenSSHInstallRoot;$env:Path"

function Repair-OpenSSHServer {
    install-sshd.ps1

    netsh advfirewall firewall show rule name=sshd dir=in | Out-Null

    if (-not $?) {
        netsh advfirewall firewall add rule name=sshd dir=in action=allow protocol=TCP localport=22 | Out-Null
    }

    New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Value "${env:SystemRoot}\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force | Out-Null
    New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShellCommandOption -Value '-Command' -PropertyType String -Force | Out-Null

    takeown /F $OpenSSHInstallRoot /R /A | Out-Null
    icacls $OpenSSHInstallRoot '/grant:r' 'Administrators:F' 'SYSTEM:F' 'Authenticated Users:RX' '/inheritance:r' /T | Out-Null

    FixHostFilePermissions.ps1 -Confirm:$false
    FixUserFilePermissions.ps1 -Confirm:$false

    New-Item -Path "$env:ProgramData\ssh" -ItemType Directory -Force | Out-Null

    Set-Content -Path "$env:ProgramData\ssh\sshd_config" -Value $SshdConfig -Encoding UTF8
    Set-Service -Name sshd -StartupType Automatic
    Start-Service -Name sshd
}

function Install-OpenSSHServer {
    param (
        [Parameter()]
        [switch]
        $Force
    )

    Write-Host 'Info: Obtaining OpenSSH release link from https://github.com/PowerShell/Win32-OpenSSH/releases/latest'

    try {
        $response = Invoke-WebRequest -Uri 'https://github.com/PowerShell/Win32-OpenSSH/releases/latest' -MaximumRedirection 0 -TimeoutSec 10 -Proxy $env:http_proxy -ErrorAction SilentlyContinue
        $location = $response.Headers.Location
    } catch {
        # It's disgusting that there are different behaviors in different PowerShell versions
        if (($null -ne $_.Exception.Response) -and ($_.Exception.Response.StatusCode -eq 302)) {
            $response = $_.Exception.Response
            $location = $response.Headers.Location.AbsoluteUri
        } else {
            Write-Host "Error: $_`n"

            exit 1
        }
    }

    $newRelease = $location.Substring($location.LastIndexOf('/') + 1).ToLower().Trim()

    if (Test-Path -Path $OpenSSHReleaseFile) {
        $oldRelease = (Get-Content -Path $OpenSSHReleaseFile).ToLower().Trim()

        if (($oldRelease -eq $newRelease) -and (-not $Force)) {
            Write-Host 'Info: OpenSSH is newest.'

            exit 0
        }
    }

    $url = $location.Replace('tag', 'download') + '/' + $OpenSSHArchiveFullName

    $archiveFileDir = Join-Path -Path $env:TEMP -ChildPath "$OpenSSHArchiveNameStem($newRelease)"

    if (-not (Test-Path -Path $archiveFileDir)) {
        New-Item -Path $archiveFileDir -ItemType Directory -Force | Out-Null
    }

    $archiveFile = Join-Path -Path $archiveFileDir -ChildPath $OpenSSHArchiveFullName

    Write-Host "Info: Downloading $OpenSSHArchiveFullName"

    Invoke-WebRequest -Uri $url -TimeoutSec 10 -Proxy $env:http_proxy -OutFile $archiveFile

    Write-Host 'Info: Uninstalling old OpenSSH'

    try {
        uninstall-sshd.ps1

        Remove-Item -Path $OpenSSHInstallRoot -Recurse -Force
    } catch {}

    Write-Host "Info: Copying the contents of the directory '$OpenSSHArchiveNameStem' in '$OpenSSHArchiveFullName' to '$OpenSSHInstallRoot'."

    $archiveData = Join-Path -Path $archiveFileDir -ChildPath $OpenSSHArchiveNameStem

    if (Test-Path -Path $archiveData) {
        Remove-Item -Path $archiveData -Recurse -Force
    }

    Expand-Archive -Path $archiveFile -DestinationPath $archiveFileDir -Force
    New-Item -Path $OpenSSHInstallRoot -ItemType Directory -Force | Out-Null
    Copy-Item -Path "$archiveData\*" -Destination $OpenSSHInstallRoot -Recurse -Force

    Set-Content -Path $OpenSSHReleaseFile -Value $newRelease -Force

    Write-Host "Info: Calling $($PSCmdlet.MyInvocation.MyCommand) -Repair"

    Repair-OpenSSHServer
}

function Uninstall-OpenSSHServer {
    uninstall-sshd.ps1

    Remove-Item -Path $OpenSSHInstallRoot -Recurse -Force
    Remove-Item -Path "$env:ProgramData\ssh" -Recurse -Force
}

if ($Uninstall) {
    Uninstall-OpenSSHServer

    exit 0
}

if ($Repair) {
    Repair-OpenSSHServer

    exit 0
}

Install-OpenSSHServer -Force:$Force
