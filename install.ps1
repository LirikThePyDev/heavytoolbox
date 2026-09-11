# Force TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Root = "C:\HeavyToolbox"
$Runtimes = "$Root\runtimes"
$Tools = "$Root\tools"

# Downloads Configuration
$Downloads = @(
    @{
        Url = "https://www.python.org/ftp/python/3.11.9/python-3.11.9-embed-amd64.zip"
        Dest = "$Runtimes\python.zip"
        ExtractTo = "$Runtimes\python"
    },
    @{
        Url = "https://github.com/ffuf/ffuf/releases/download/v2.1.0/ffuf_2.1.0_windows_amd64.zip"
        Dest = "$Tools\ffuf\ffuf.zip"
        ExtractTo = "$Tools\ffuf"
    },
    @{
        Url = "https://github.com/andrew-d-cole/netcat-portable/releases/download/v1.0/netcat.zip"
        Dest = "$Tools\netcat\netcat.zip"
        ExtractTo = "$Tools\netcat"
    }
)

# Sysinternals Direct Downloads
$Sysinternals = @(
    "PsExec.exe", "ProcDump.exe", "AccessChk.exe"
)

function Unpack-ArchiveSafe {
    param($ZipFile, $Destination)
    try {
        Write-Host "Extracting $ZipFile to $Destination..." -ForegroundColor Cyan
        if (!(Test-Path $Destination)) { New-Item -ItemType Directory -Path $Destination -Force }
        Expand-Archive -Path $ZipFile -DestinationPath $Destination -Force
    } catch {
        Write-Host "Expand-Archive failed. Falling back to Shell.Application COM object..." -ForegroundColor Yellow
        try {
            $shell = New-Object -ComObject Shell.Application
            $zipFolder = $shell.NameSpace($ZipFile)
            $destFolder = $shell.NameSpace($Destination)
            $destFolder.CopyHere($zipFolder.Items(), 0x10)
        } catch {
            Write-Error "Failed to extract $ZipFile using all methods."
        }
    }
}

# Process Main Downloads
foreach ($item in $Downloads) {
    try {
        Write-Host "Downloading $($item.Url)..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $item.Url -OutFile $item.Dest -UseBasicParsing
        Unpack-ArchiveSafe -ZipFile $item.Dest -Destination $item.ExtractTo
        Remove-Item $item.Dest -Force
    } catch {
        Write-Host "Failed to process $($item.Url) - $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Process Sysinternals
foreach ($bin in $Sysinternals) {
    try {
        Write-Host "Downloading Sysinternals $bin..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri "https://sysinternals.com/$bin" -OutFile "$Tools\sysinternals\$bin" -UseBasicParsing
    } catch {
        Write-Host "Failed to download ${bin} - $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Setup Documentation Placeholders
$Docs = @{
    "$Tools\metasploit-framework\README.txt" = "METASPLOIT FRAMEWORK INSTALLATION`n==============================`n1. Download installer from https://www.metasploit.com/download`n2. Install and ensure Antivirus exclusions are set for C:\HeavyToolbox`n3. Run msfconsole.bat to initialize."
    "$Tools\hashcat\README.txt" = "HASHCAT INSTALLATION`n===================`n1. Download portable binaries from https://hashcat.net/hashcat/`n2. Extract to this folder.`n3. Ensure OpenCL/CUDA drivers are installed for GPU acceleration."
    "$Tools\wireshark\README.txt" = "WIRESHARK INSTALLATION`n====================`n1. Download installer from https://www.wireshark.org/download.html`n2. Install Npcap (required for packet capture).`n3. Install Wireshark and Tshark."
}

foreach ($path in $Docs.Keys) {
    $Docs[$path] | Out-File -FilePath $path -Encoding utf8
}

Write-Host "Installation process completed." -ForegroundColor Green
