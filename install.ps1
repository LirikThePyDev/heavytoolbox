# Force TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Dynamically resolve root relative to script execution location
$Root = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Runtimes = "$Root\runtimes"
$Tools = "$Root\tools"

# Ensure core structural directories exist at launch
@($Runtimes, $Tools, "$Tools\sysinternals", "$Tools\metasploit-framework", "$Tools\hashcat", "$Tools\wireshark") | ForEach-Object {
    if (!(Test-Path $_)) { New-Item -ItemType Directory -Path $_ -Force | Out-Null }
}

# Advanced Downloads Configuration (Zero-Configuration Pipeline)
$Downloads = @(
    @{
        Name = "Python 3.11"
        Url  = "https://python.org"
        Dest = "$Runtimes\python.zip"
        Ext  = "$Runtimes\python"
    },
    @{
        Name = "Ffuf Web Fuzzer"
        Url  = "https://github.com"
        Dest = "$Tools\ffuf\ffuf.zip"
        Ext  = "$Tools\ffuf"
    },
    @{
        Name = "Netcat Portable"
        Url  = "https://github.com"
        Dest = "$Tools\netcat\netcat.zip"
        Ext  = "$Tools\netcat"
    },
    @{
        Name = "Mimikatz Security Audit Tool"
        Url  = "https://github.com"
        Dest = "$Tools\mimikatz\mimikatz.zip"
        Ext  = "$Tools\mimikatz"
    },
    @{
        Name = "Nmap Network Scanner (Portable)"
        Url  = "https://nmap.org"
        Dest = "$Tools\nmap\nmap.zip"
        Ext  = "$Tools\nmap"
    }
)

# Sysinternals Engine Components
$Sysinternals = @("PsExec.exe", "ProcDump.exe", "AccessChk.exe")

function Unpack-ArchiveSafe {
    param($ZipFile, $Destination)
    try {
        Write-Host "[*] Extracting $ZipFile..." -ForegroundColor Cyan
        if (!(Test-Path $Destination)) { New-Item -ItemType Directory -Path $Destination -Force | Out-Null }
        Expand-Archive -Path $ZipFile -DestinationPath $Destination -Force
    } catch {
        Write-Host "[!] Expand-Archive failed. Utilizing Shell.Application fallback..." -ForegroundColor Yellow
        try {
            $shell = New-Object -ComObject Shell.Application
            $zipFolder = $shell.NameSpace($ZipFile)
            $destFolder = $shell.NameSpace($Destination)
            $destFolder.CopyHere($zipFolder.Items(), 0x10)
        } catch {
            Write-Error "[-] Failed to extract $ZipFile cleanly using primary or fallback engines."
        }
    }
}

# Run the Main Deployment Routine
foreach ($item in $Downloads) {
    try {
        $targetParent = Split-Path -Parent $item.Dest
        if (!(Test-Path $targetParent)) { New-Item -ItemType Directory -Path $targetParent -Force | Out-Null }

        Write-Host "[+] Deploying $($item.Name)..." -ForegroundColor Green
        Invoke-WebRequest -Uri $item.Url -OutFile $item.Dest -UseBasicParsing
        Unpack-ArchiveSafe -ZipFile $item.Dest -Destination $item.Ext
        Remove-Item $item.Dest -Force
    } catch {
        Write-Host "[-] Critical failure deploying $($item.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Normalize Nmap Directory Structure if nested during zip unpack
if (Test-Path "$Tools\nmap\nmap-7.95") {
    Write-Host "[*] Standardizing Nmap environment paths..." -ForegroundColor Cyan
    Move-Item -Path "$Tools\nmap\nmap-7.95\*" -Destination "$Tools\nmap" -Force
    Remove-Item -Path "$Tools\nmap\nmap-7.95" -Recurse -Force
}

# Fix Python Embedded Isolation trap so custom scripting extensions work seamlessly
$pthFile = "$Runtimes\python\python311._pth"
if (Test-Path $pthFile) {
    (Get-Content $pthFile) | ForEach-Object { $_ -replace '#import site', 'import site' } | Set-Content $pthFile
}

# Run the Sysinternals Deployment Routine
foreach ($bin in $Sysinternals) {
    try {
        Write-Host "[+] Stream-loading Sysinternals $bin..." -ForegroundColor Green
        Invoke-WebRequest -Uri "https://sysinternals.com" -OutFile "$Tools\sysinternals\$bin" -UseBasicParsing
    } catch {
        Write-Host "[-] Failed to stream-load ${bin}: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Setup Manual-Heavy Enterprise Tool Documentation Placeholders
$Docs = @{
    "$Tools\metasploit-framework\README.txt" = "METASPLOIT FRAMEWORK INSTALLATION`n==============================`n1. Download installer from https://metasploit.com`n2. Install and ensure Antivirus exclusions are set for C:\HeavyToolbox`n3. Run msfconsole.bat to initialize."
    "$Tools\hashcat\README.txt" = "HASHCAT INSTALLATION`n===================`n1. Download portable binaries from https://hashcat.net`n2. Extract to this folder.`n3. Ensure OpenCL/CUDA drivers are installed for GPU acceleration."
    "$Tools\wireshark\README.txt" = "WIRESHARK INSTALLATION`n====================`n1. Download installer from https://wireshark.org`n2. Install Npcap (required for packet capture).`n3. Install Wireshark and Tshark."
}

foreach ($path in $Docs.Keys) {
    $Docs[$path] | Out-File -FilePath $path -Encoding utf8
}

Write-Host "`n[+] HeavyToolbox Wizard Deployment Complete. Launch console.bat to operate." -ForegroundColor Green
