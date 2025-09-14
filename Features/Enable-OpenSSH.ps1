#Requires -Version 5.1
#Requires -RunAsAdministrator

[CmdletBinding(DefaultParameterSetName = 'EnableAll')]
param (
    [Parameter(Mandatory = $true, ParameterSetName = 'ServerOnly')]
    [switch]
    $ServerOnly,

    [Parameter(Mandatory = $true, ParameterSetName = 'ClientOnly')]
    [switch]
    $ClientOnly,

    [Parameter(Mandatory = $true, ParameterSetName = 'ResetServerConfig')]
    [switch]
    $ResetServerConfig,

    [Parameter(Mandatory = $true, ParameterSetName = 'ResetClientConfig')]
    [switch]
    $ResetClientConfig,

    [Parameter(Mandatory = $true, ParameterSetName = 'RepairServerPermissions')]
    [switch]
    $RepairServerPermissions,

    [Parameter(Mandatory = $true, ParameterSetName = 'RepairClientPermissions')]
    [switch]
    $RepairClientPermissions
)

$ErrorActionPreference = 'Stop'

$osVersion = [System.Environment]::OSVersion.Version

if (($osVersion.Major -lt 10) -or ($osVersion.Build -lt 17763)) {
    throw 'The operating system must be at least Windows 10 (Version 1809).'
}

$SSHRegistryPath = 'HKLM:\Software\OpenSSH'
$SSHAgentRegistryPath = "$SSHRegistryPath\Agent"

$SSHProgramDataPath = "$env:ProgramData\ssh"

$SSHServerConfigurationPath = "$SSHProgramDataPath\sshd_config"
$SSHServerConfigurationDirectoryPath = "$SSHProgramDataPath\sshd_config.d"

$SSHServerConfigurationContent = @'
# This is the sshd server system-wide configuration file.
# See sshd_config(5) for more information.
#
# See: https://learn.microsoft.com/en-us/windows-server/administration/OpenSSH/openssh-server-configuration
#

Include __PROGRAMDATA__/ssh/sshd_config.d/*.conf

# ==============================================================
# = Network
# ==============================================================

#ListenAddress 0.0.0.0
#ListenAddress ::
#Port 22

# ==============================================================
# = Host keys
# ==============================================================

HostKey __PROGRAMDATA__/ssh/ssh_host_ed25519_key
HostKey __PROGRAMDATA__/ssh/ssh_host_ecdsa_key
HostKey __PROGRAMDATA__/ssh/ssh_host_rsa_key

HostKeyAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,sk-ecdsa-sha2-nistp256-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ecdsa-sha2-nistp256@openssh.com,ssh-ed25519-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-v01@openssh.com,ssh-ed25519,ecdsa-sha2-nistp521,ecdsa-sha2-nistp384-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,ecdsa-sha2-nistp384,rsa-sha2-512,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp256,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-256

# ==============================================================
# = Cryptography
# ==============================================================

KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com

RekeyLimit 1G 1H
FingerprintHash sha256

# ==============================================================
# = Authentication
# ==============================================================

AuthenticationMethods publickey
AuthorizedKeysFile .ssh/authorized_keys
PubkeyAuthentication yes
PubkeyAcceptedAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,sk-ecdsa-sha2-nistp256-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ecdsa-sha2-nistp256@openssh.com,ssh-ed25519-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-v01@openssh.com,ssh-ed25519,ecdsa-sha2-nistp521,ecdsa-sha2-nistp384-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,ecdsa-sha2-nistp384,rsa-sha2-512,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp256,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-256
RequiredRSASize 4096

PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no

GSSAPIAuthentication no

CASignatureAlgorithms sk-ssh-ed25519@openssh.com,sk-ecdsa-sha2-nistp256@openssh.com,ssh-ed25519,ecdsa-sha2-nistp521,ecdsa-sha2-nistp384,rsa-sha2-512,ecdsa-sha2-nistp256,rsa-sha2-256

# ==============================================================
# = Access Control
# ==============================================================

UsePAM yes
PermitRootLogin no

# ==============================================================
# = Session Limits
# ==============================================================

LoginGraceTime 30
MaxAuthTries 3
MaxStartups 10:50:50
MaxSessions 10

# ==============================================================
# = Connection
# ==============================================================

TCPKeepAlive no
ClientAliveCountMax 0
ClientAliveInterval 300

# ==============================================================
# = Forwarding
# ==============================================================

AllowAgentForwarding no
AllowTcpForwarding yes

GatewayPorts no
PermitListen any
PermitOpen any

# ==============================================================
# = Environment and File Access
# ==============================================================

ChrootDirectory none

# ==============================================================
# = Logging
# ==============================================================

LogLevel VERBOSE
SyslogFacility AUTH

# ==============================================================
# = Miscellaneous
# ==============================================================

Compression no
UseDNS yes
PermitTTY yes
VersionAddendum none

# ==============================================================
# = Subsystem
# ==============================================================

Subsystem sftp /usr/lib/sftp-server -f AUTHPRIV -l INFO

# ==============================================================
# = Authentication - Administrators
# ==============================================================

Match Group administrators
    AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys
'@

$SSHClientConfigurationPath = "$SSHProgramDataPath\ssh_config"
$SSHClientConfigurationDirectoryPath = "$SSHProgramDataPath\ssh_config.d"

$SSHClientConfigurationContent = @'
# This is the ssh client system-wide configuration file.
# See ssh_config(5) for more information.
#

Include __PROGRAMDATA__/ssh/ssh_config.d/*.conf

Host *
# ==============================================================
# = Host keys
# ==============================================================

    HostKeyAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,sk-ecdsa-sha2-nistp256-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ecdsa-sha2-nistp256@openssh.com,ssh-ed25519-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-v01@openssh.com,ssh-ed25519,ecdsa-sha2-nistp521,ecdsa-sha2-nistp384-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,ecdsa-sha2-nistp384,rsa-sha2-512,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp256,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-256

# ==============================================================
# = Cryptography
# ==============================================================

    KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256
    Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
    MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com

    RekeyLimit 1G 1H
    FingerprintHash sha256

# ==============================================================
# = Authentication
# ==============================================================

    PreferredAuthentications publickey,keyboard-interactive,password
    PubkeyAuthentication yes
    PubkeyAcceptedAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,sk-ecdsa-sha2-nistp256-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ecdsa-sha2-nistp256@openssh.com,ssh-ed25519-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-v01@openssh.com,ssh-ed25519,ecdsa-sha2-nistp521,ecdsa-sha2-nistp384-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,ecdsa-sha2-nistp384,rsa-sha2-512,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp256,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-256
    RequiredRSASize 2048

    PasswordAuthentication yes
    KbdInteractiveAuthentication yes

    CASignatureAlgorithms sk-ssh-ed25519@openssh.com,sk-ecdsa-sha2-nistp256@openssh.com,ssh-ed25519,ecdsa-sha2-nistp521,ecdsa-sha2-nistp384,rsa-sha2-512,ecdsa-sha2-nistp256,rsa-sha2-256

# ==============================================================
# = Connection
# ==============================================================

    TCPKeepAlive yes
    ServerAliveInterval 30
    ServerAliveCountMax 3

# ==============================================================
# = Forwarding
# ==============================================================

    ForwardAgent no
    ForwardX11 no
    GatewayPorts no

# ==============================================================
# = Keys
# ==============================================================

    AddKeysToAgent yes
    IdentitiesOnly no

    HashKnownHosts yes
    StrictHostKeyChecking yes
    VisualHostKey no

# ==============================================================
# = Logging
# ==============================================================

    LogLevel INFO
    SyslogFacility USER

# ==============================================================
# = Miscellaneous
# ==============================================================

    Compression no
    VerifyHostKeyDNS no
    VersionAddendum none
'@

# The immediate child item of the "$SSHProgramDataPath" directory.
$SSHServerWorldReadableSystemItems = @(
    'sshd.pid',
    'sshd_config',
    'sshd_config.d',
    'sshrc',
    'moduli'
)
$SSHClientWorldReadableSystemItems = @(
    'ssh_config',
    'ssh_config.d',
    'ssh_known_hosts',
    'moduli'
)

# Owner: Administrators; Group: SYSTEM; Administrators: FullControl; SYSTEM: FullControl;
$SystemSensitiveRegistrySddl = 'O:BAG:SYD:PAI(A;OICI;KA;;;BA)(A;OICI;KA;;;SY)'

# Owner: Administrators; Group: SYSTEM; Administrators: FullControl; SYSTEM: FullControl; Authenticated Users: ReadKey
$SystemWorldReadableRegistrySddl = 'O:BAG:SYD:PAI(A;OICI;KA;;;BA)(A;OICI;KA;;;SY)(A;OICI;KR;;;AU)'

# Owner: Administrators; Group: SYSTEM; Administrators: FullControl; SYSTEM: FullControl;
$SystemSensitiveFileSddl = 'O:BAG:SYD:PAI(A;OICI;FA;;;BA)(A;OICI;FA;;;SY)'

# Owner: Administrators; Group: SYSTEM; Administrators: FullControl; SYSTEM: FullControl; Authenticated Users: ReadAndExecute, Synchronize
$SystemWorldReadableFileSddl = 'O:BAG:SYD:PAI(A;OICI;FA;;;BA)(A;OICI;FA;;;SY)(A;OICI;FRFX;;;AU)'

# Owner: <SID>; Owner: FullControl; Administrators: FullControl; SYSTEM: FullControl;
function Get-UserSensitiveFileSddl {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SID
    )

    "O:${SID}D:PAI(A;OICI;FA;;;${SID})(A;OICI;FA;;;BA)(A;OICI;FA;;;SY)"
}

# Owner: <SID>; Owner: FullControl; Administrators: FullControl; SYSTEM: FullControl; Authenticated Users: ReadAndExecute, Synchronize
function Get-UserWorldReadableFileSddl {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SID
    )

    "O:${SID}D:PAI(A;OICI;FA;;;${SID})(A;OICI;FA;;;BA)(A;OICI;FA;;;SY)(A;OICI;FRFX;;;AU)"
}

function Set-AclSecurityDescriptor {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Sddl
    )

    $acl = Get-Acl -Path $Path
    $acl.SetSecurityDescriptorSddlForm($Sddl)

    Set-Acl -Path $Path -AclObject $acl
}

function Set-SSHServerConfiguration {
    Set-Content -Path $SSHServerConfigurationPath -Value $SSHServerConfigurationContent -Encoding UTF8 -Force
}

function Set-SSHServerDefaultShell {
    Set-ItemProperty -Path $SSHRegistryPath -Name DefaultShell -Value "${env:SystemRoot}\System32\WindowsPowerShell\v1.0\powershell.exe" -Type String
    Set-ItemProperty -Path $SSHRegistryPath -Name DefaultShellCommandOption -Value '-Command' -Type String
}

function Set-SSHClientConfiguration {
    Set-Content -Path $SSHClientConfigurationPath -Value $SSHClientConfigurationContent -Encoding UTF8 -Force
}

function Get-SSHUserConfigurationDirectory {
    Get-ChildItem -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\ProfileList' -ErrorAction SilentlyContinue | ForEach-Object {
        $properties = Get-ItemProperty -Path $_.PSPath -Name ProfileImagePath -ErrorAction SilentlyContinue

        if ($properties) {
            $userProfilePath = $properties.ProfileImagePath
            $userSID = $properties.PSChildName
            $userSSHProgramDataPath = Join-Path -Path $userProfilePath -ChildPath '.ssh'

            if (Test-Path -Path $userSSHProgramDataPath) {
                [PSCustomObject]@{
                    Path    = $userSSHProgramDataPath
                    UserSID = $userSID
                }
            }
        }
    }
}

function Repair-SSHServerFilePermissions {
    if (Test-Path -Path $SSHProgramDataPath) {
        Set-AclSecurityDescriptor -Path $SSHProgramDataPath -Sddl $SystemWorldReadableFileSddl

        Get-ChildItem "$SSHProgramDataPath\*" -Exclude $SSHServerWorldReadableSystemItems -Force -ErrorAction SilentlyContinue | ForEach-Object {
            Set-AclSecurityDescriptor -Path $_.FullName -Sddl $SystemSensitiveFileSddl

            if ($_.PSIsContainer) {
                Get-ChildItem -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
                    Set-AclSecurityDescriptor -Path $_.FullName -Sddl $SystemSensitiveFileSddl
                }
            }
        }

        Get-ChildItem "$SSHProgramDataPath\*" -Include $SSHServerWorldReadableSystemItems -Force -ErrorAction SilentlyContinue | ForEach-Object {
            Set-AclSecurityDescriptor -Path $_.FullName -Sddl $SystemWorldReadableFileSddl

            if ($_.PSIsContainer) {
                Get-ChildItem -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
                    Set-AclSecurityDescriptor -Path $_.FullName -Sddl $SystemWorldReadableFileSddl
                }
            }
        }
    }

    Get-SSHUserConfigurationDirectory | ForEach-Object {
        Set-AclSecurityDescriptor -Path $_.Path -Sddl (Get-UserSensitiveFileSddl -SID $_.UserSID)

        $authorizedKeysPath = Join-Path -Path $_.Path -ChildPath 'authorized_keys'

        if (Test-Path -Path $authorizedKeysPath) {
            Set-AclSecurityDescriptor -Path $authorizedKeysPath -Sddl (Get-UserSensitiveFileSddl -SID $_.UserSID)
        }
    }
}

function Repair-SSHClientFilePermissions {
    if (Test-Path -Path $SSHProgramDataPath) {
        Set-AclSecurityDescriptor -Path $SSHProgramDataPath -Sddl $SystemWorldReadableFileSddl

        Get-ChildItem "$SSHProgramDataPath\*" -Include $SSHClientWorldReadableSystemItems -Force -ErrorAction SilentlyContinue | ForEach-Object {
            Set-AclSecurityDescriptor -Path $_.FullName -Sddl $SystemWorldReadableFileSddl

            if ($_.PSIsContainer) {
                Get-ChildItem -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
                    Set-AclSecurityDescriptor -Path $_.FullName -Sddl $SystemWorldReadableFileSddl
                }
            }
        }
    }

    Get-SSHUserConfigurationDirectory | ForEach-Object {
        Set-AclSecurityDescriptor -Path $_.Path -Sddl (Get-UserSensitiveFileSddl -SID $_.UserSID)

        Get-ChildItem -Path $_.Path -Recurse -Force | ForEach-Object {
            Set-AclSecurityDescriptor -Path $_.Path -Sddl (Get-UserSensitiveFileSddl -SID $_.UserSID)
        }
    }
}

function Repair-SSHRegistryPermissions {
    if (Test-Path -Path $SSHRegistryPath) {
        Set-AclSecurityDescriptor -Path $SSHRegistryPath -Sddl $SystemWorldReadableRegistrySddl
    }
}

function Repair-SSHHAgentRegistryPermissions {
    if (Test-Path -Path $SSHAgentRegistryPath) {
        Set-AclSecurityDescriptor -Path $SSHAgentRegistryPath -Sddl $SystemSensitiveRegistrySddl
    }
}

function Get-SSHServerPortNumberFromConfiguration {
    $portNumbers = Get-Item -Path @($SSHServerConfigurationPath, "$SSHServerConfigurationDirectoryPath\*.conf") -Force -ErrorAction SilentlyContinue |
        Select-String -Pattern '^\s*Port\s+(\d+)' | ForEach-Object { [int]::Parse($_.Matches[0].Groups[1].Value) } |
        Select-Object -Unique

    if ($portNumbers) {
        $portNumbers
    } else {
        22
    }
}

function Add-SSHServerFirewallRules {
    Get-SSHServerPortNumberFromConfiguration | ForEach-Object {
        $null = netsh advfirewall firewall delete rule name=sshd protocol=tcp localport=$_
        $null = netsh advfirewall firewall add rule name=sshd protocol=tcp localport=$_ dir=in action=allow
    }
}

function Remove-SSHServerFirewallRules {
    $null = Get-SSHServerPortNumberFromConfiguration | ForEach-Object { netsh advfirewall firewall delete rule name=sshd protocol=tcp localport=$_ }
}

function Test-OpenSSHClientInstalled {
    [bool](Get-WindowsCapability -Online | Where-Object { ($_.Name -like 'OpenSSH.Client*') -and ($_.State -eq 'Installed') })
}

function Enable-OpenSSHClient {
    Write-Host 'Enabling Windows feature: OpenSSH Client'
    Get-WindowsCapability -Online | Where-Object { ($_.Name -like 'OpenSSH.Client*') -and ($_.State -ne 'Installed') } | Add-WindowsCapability -Online
}

function Test-OpenSSHServerInstalled {
    [bool](Get-WindowsCapability -Online | Where-Object { ($_.Name -like 'OpenSSH.Server*') -and ($_.State -eq 'Installed') })
}

function Enable-OpenSSHServer {
    Write-Host 'Enabling Windows feature: OpenSSH Server'
    Get-WindowsCapability -Online | Where-Object { ($_.Name -like 'OpenSSH.Server*') -and ($_.State -ne 'Installed') } | Add-WindowsCapability -Online
}

function New-SSHSystemConfigurationDirectory {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $Server,

        [Parameter()]
        [switch]
        $Client
    )

    if (-not (Test-Path -Path $SSHProgramDataPath)) {
        New-Item -Path $SSHProgramDataPath -ItemType Directory | Out-Null
        Set-AclSecurityDescriptor -Path $SSHProgramDataPath -Sddl $SystemWorldReadableFileSddl
    }

    if ($Server -and (-not (Test-Path -Path $SSHServerConfigurationDirectoryPath))) {
        New-Item -Path $SSHServerConfigurationDirectoryPath -ItemType Directory | Out-Null
        Set-AclSecurityDescriptor -Path $SSHServerConfigurationDirectoryPath -Sddl $SystemWorldReadableFileSddl
    }

    if ($Client -and (-not (Test-Path -Path $SSHClientConfigurationDirectoryPath))) {
        New-Item -Path $SSHClientConfigurationDirectoryPath -ItemType Directory | Out-Null
        Set-AclSecurityDescriptor -Path $SSHClientConfigurationDirectoryPath -Sddl $SystemWorldReadableFileSddl
    }
}

function New-SSHConfigurationRegistryKey {
    if (-not (Test-Path -Path $SSHRegistryPath)) {
        New-Item -Path $SSHRegistryPath | Out-Null
        Set-AclSecurityDescriptor -Path $SSHRegistryPath -Sddl $SystemWorldReadableRegistrySddl
    }
}

function Initialize-SSHClient {
    if (Test-OpenSSHClientInstalled) {
        return
    }

    New-SSHSystemConfigurationDirectory -Client

    if (-not (Test-Path -Path $SSHClientConfigurationPath)) {
        Set-SSHClientConfiguration
    }

    Enable-OpenSSHClient

    Set-Service -Name ssh-agent -StartupType Manual
}

function Initialize-SSHServer {
    if (Test-OpenSSHServerInstalled) {
        return
    }

    Remove-SSHServerFirewallRules

    New-SSHSystemConfigurationDirectory -Server

    if (-not (Test-Path -Path $SSHServerConfigurationPath)) {
        Set-SSHServerConfiguration
    }

    New-SSHConfigurationRegistryKey
    Set-SSHServerDefaultShell

    Enable-OpenSSHServer

    Add-SSHServerFirewallRules

    Set-Service -Name sshd -StartupType Automatic
    Start-Service -Name sshd
}

function Reset-SSHServerConfiguration {
    Remove-SSHServerFirewallRules

    New-SSHSystemConfigurationDirectory -Server
    Set-SSHServerConfiguration
    Set-SSHServerDefaultShell

    Add-SSHServerFirewallRules

    Repair-SSHServerFilePermissions
}

function Reset-SSHClientConfiguration {
    New-SSHSystemConfigurationDirectory -Client
    Set-SSHClientConfiguration

    Repair-SSHClientFilePermissions
}

if ($ClientOnly) {
    Initialize-SSHClient
} elseif ($ServerOnly) {
    Initialize-SSHServer
} elseif ($ResetServerConfig) {
    Reset-SSHServerConfiguration
} elseif ($ResetClientConfig) {
    Reset-SSHClientConfiguration
} elseif ($RepairServerPermissions) {
    Repair-SSHRegistryPermissions
    Repair-SSHServerFilePermissions
} elseif ($RepairClientPermissions) {
    Repair-SSHRegistryPermissions
    Repair-SSHHAgentRegistryPermissions
    Repair-SSHClientFilePermissions
} else {
    Initialize-SSHClient
    Initialize-SSHServer
}
