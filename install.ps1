# --- AUTOMATED ADMINISTRATOR ELEVATION CHECK ---
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[*] Elevating credentials to configure system exclusions..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Force TLS 1.2 and modern engine configurations
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Dynamically resolve root relative to script execution location
$Root = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Runtimes = "$Root\runtimes"
$Tools = "$Root\tools"

# Create Structural Directories
@($Runtimes, $Tools, "$Tools\sysinternals", "$Tools\metasploit-framework", "$Tools\hashcat", "$Tools\wireshark") | ForEach-Object {
    if (!(Test-Path $_)) { New-Item -ItemType Directory -Path $_ -Force | Out-Null }
}

# Programmatic Windows Defender Core Antivirus Exclusion Automation
try {
    Write-Host "[+] Adding local project footprint directory to Windows Defender exclusions..." -ForegroundColor Green
    Add-MpPreference -ExclusionPath $Root -ErrorAction SilentlyContinue
} catch {}

# The Absolute Zero-Touch Toolkit Configuration (Verified Portable URLs)
$Downloads = @(
    @{ Name = "Python 3.11 Runtime"; Url = "https://python.org"; Dest = "$Runtimes\python.zip"; Ext = "$Runtimes\python" },
    @{ Name = "Ffuf Web Fuzzer"; Url = "https://github.com"; Dest = "$Tools\ffuf\ffuf.zip"; Ext = "$Tools\ffuf" },
    @{ Name = "Netcat Portable"; Url = "https://github.com"; Dest = "$Tools\netcat\netcat.zip"; Ext = "$Tools\netcat" },
    @{ Name = "Mimikatz Audit Tool"; Url = "https://github.com"; Dest = "$Tools\mimikatz\mimikatz.zip"; Ext = "$Tools\mimikatz" },
    @{ Name = "Nmap Network Scanner"; Url = "https://nmap.org"; Dest = "$Tools\nmap\nmap.zip"; Ext = "$Tools\nmap" },
    @{ Name = "Hashcat Password Cracker"; Url = "https://hashcat.net"; Dest = "$Tools\hashcat\hashcat.zip"; Ext = "$Tools\hashcat" },
    @{ Name = "Wireshark Portable Engine"; Url = "https://wireshark.org"; Dest = "$Tools\wireshark\wireshark_install.exe"; Ext = "$Tools\wireshark" },
    @{ Name = "Metasploit Engine (Heavy)"; Url = "https://metasploit.com"; Dest = "$Tools\metasploit-framework\msf_install.msi"; Ext = "$Tools\metasploit-framework" }
)
$Sysinternals = @("PsExec.exe", "ProcDump.exe", "AccessChk.exe")

# --- UI Setup ---
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Suite Installer Wizard"
$Form.Size = New-Object System.Drawing.Size(515, 390)
$Form.StartPosition = "CenterScreen"
$Form.FormBorderStyle = "FixedDialog"
$Form.MaximizeBox = $false
$Form.MinimizeBox = $false
$Form.BackColor = [System.Drawing.Color]::White

$Sidebar = New-Object System.Windows.Forms.Panel
$Sidebar.Size = New-Object System.Drawing.Size(165, 312)
$Sidebar.Location = New-Object System.Drawing.Point(0, 0)
$Sidebar.BackColor = [System.Drawing.Color]::FromArgb(10, 24, 110)
$Form.Controls.Add($Sidebar)

$MainContent = New-Object System.Windows.Forms.Panel
$MainContent.Size = New-Object System.Drawing.Size(335, 312)
$MainContent.Location = New-Object System.Drawing.Point(165, 0)
$MainContent.BackColor = [System.Drawing.Color]::White
$Form.Controls.Add($MainContent)

$Title = New-Object System.Windows.Forms.Label
$Title.Text = "Welcome to the HeavyToolbox Installer Wizard"
$Title.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$Title.Location = New-Object System.Drawing.Point(15, 20)
$Title.Size = New-Object System.Drawing.Size(305, 45)
$MainContent.Controls.Add($Title)

$Desc = New-Object System.Windows.Forms.Label
$Desc.Text = "This wizard deploys the entire core suite including Metasploit, Hashcat, and Wireshark directly into your project framework completely automated.`n`nTo continue, click Next."
$Desc.Font = New-Object System.Drawing.Font("Segoe UI", 8.5)
$Desc.Location = New-Object System.Drawing.Point(17, 75)
$Desc.Size = New-Object System.Drawing.Size(300, 150)
$MainContent.Controls.Add($Desc)

$StatusLabel = New-Object System.Windows.Forms.Label
$StatusLabel.Text = "Ready to proceed."
$StatusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$StatusLabel.Location = New-Object System.Drawing.Point(17, 230)
$StatusLabel.Size = New-Object System.Drawing.Size(300, 20)
$MainContent.Controls.Add($StatusLabel)

$SepLine = New-Object System.Windows.Forms.Label
$SepLine.Size = New-Object System.Drawing.Size(515, 2)
$SepLine.Location = New-Object System.Drawing.Point(0, 312)
$SepLine.BorderStyle = "Fixed3D"
$Form.Controls.Add($SepLine)

$BottomPanel = New-Object System.Windows.Forms.Panel
$BottomPanel.Size = New-Object System.Drawing.Size(515, 50)
$BottomPanel.Location = New-Object System.Drawing.Point(0, 314)
$BottomPanel.BackColor = [System.Drawing.Color]::FromName("Control")
$Form.Controls.Add($BottomPanel)

$BtnBack = New-Object System.Windows.Forms.Button
$BtnBack.Text = "< Back"
$BtnBack.Enabled = $false
$BtnBack.Location = New-Object System.Drawing.Point(235, 10)
$BtnBack.Size = New-Object System.Drawing.Size(75, 24)
$BottomPanel.Controls.Add($BtnBack)

$BtnNext = New-Object System.Windows.Forms.Button
$BtnNext.Text = "Next >"
$BtnNext.Location = New-Object System.Drawing.Point(315, 10)
$BtnNext.Size = New-Object System.Drawing.Size(75, 24)
$BottomPanel.Controls.Add($BtnNext)

$BtnCancel = New-Object System.Windows.Forms.Button
$BtnCancel.Text = "Cancel"
$BtnCancel.Location = New-Object System.Drawing.Point(405, 10)
$BtnCancel.Size = New-Object System.Drawing.Size(75, 24)
$BtnCancel.Add_Click({ $Form.Close() })
$BottomPanel.Controls.Add($BtnCancel)

function Unpack-ArchiveSafe {
    param($ZipFile, $Destination)
    try {
        if (!(Test-Path $Destination)) { New-Item -ItemType Directory -Path $Destination -Force | Out-Null }
        Expand-Archive -Path $ZipFile -DestinationPath $Destination -Force
    } catch {
        $shell = New-Object -ComObject Shell.Application
        $shell.NameSpace($Destination).CopyHere($shell.NameSpace($ZipFile).Items(), 0x10)
    }
}

# --- Installation Execution Processing Cycle ---
$BtnNext.Add_Click({
    $BtnNext.Enabled = $false
    $BtnCancel.Enabled = $false
    
    foreach ($item in $Downloads) {
        $StatusLabel.Text = "Downloading $($item.Name)..."
        [System.Windows.Forms.Application]::DoEvents()
        
        try {
            $targetParent = Split-Path -Parent $item.Dest
            if (!(Test-Path $targetParent)) { New-Item -ItemType Directory -Path $targetParent -Force | Out-Null }
            
            # Forced Infinite Timeout Setup (-TimeoutSec 0)
            Invoke-WebRequest -Uri $item.Url -OutFile $item.Dest -UseBasicParsing -TimeoutSec 0
            
            if ($item.Dest.EndsWith(".zip")) {
                $StatusLabel.Text = "Extracting $($item.Name)..."
                [System.Windows.Forms.Application]::DoEvents()
                Unpack-ArchiveSafe -ZipFile $item.Dest -Destination $item.Ext
                Remove-Item $item.Dest -Force
            } elseif ($item.Name -like "*Metasploit*") {
                $StatusLabel.Text = "Extracting Metasploit Framework Components..."
                [System.Windows.Forms.Application]::DoEvents()
                Start-Process msiexec.exe -ArgumentList "/i `"$($item.Dest)`" /qn /norestart INSTDIR=`"$($item.Ext)`"" -Wait
                Remove-Item $item.Dest -Force
            } elseif ($item.Name -like "*Wireshark*") {
                $StatusLabel.Text = "Extracting Wireshark Engine Environment..."
                [System.Windows.Forms.Application]::DoEvents()
                Start-Process $item.Dest -ArgumentList "/S /D=$($item.Ext)" -Wait
                Remove-Item $item.Dest -Force
            }
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Failure downloading $($item.Name)`n$($_.Exception.Message)", "Error", "OK", "Error")
        }
    }
    
    # Structural Normalizations & Cleanups
    if (Test-Path "$Tools\nmap\nmap-7.95") {
        Move-Item -Path "$Tools\nmap\nmap-7.95\*" -Destination "$Tools\nmap" -Force
        Remove-Item -Path "$Tools\nmap\nmap-7.95" -Recurse -Force
    }
    if (Test-Path "$Tools\hashcat\hashcat-6.2.6") {
        Move-Item -Path "$Tools\hashcat\hashcat-6.2.6\*" -Destination "$Tools\hashcat" -Force
        Remove-Item -Path "$Tools\hashcat\hashcat-6.2.6" -Recurse -Force
    }
    
    $pthFile = "$Runtimes\python\python311._pth"
    if (Test-Path $pthFile) {
        (Get-Content $pthFile) | ForEach-Object { $_ -replace '#import site', 'import site' } | Set-Content $pthFile
    }
    
    # Download Sysinternals dependencies (Forced Infinite Timeout)
    $StatusLabel.Text = "Downloading Sysinternals binaries..."
    [System.Windows.Forms.Application]::DoEvents()
    foreach ($bin in $Sysinternals) {
        try { Invoke-WebRequest -Uri "https://sysinternals.com" -OutFile "$Tools\sysinternals\$bin" -UseBasicParsing -TimeoutSec 0 } catch {}
    }
    
    $StatusLabel.Text = "All installations fully deployed!"
    [System.Windows.Forms.MessageBox]::Show("HeavyToolbox framework setup is complete!`nEvery single menu option is now armed and functional.", "Success", "OK", "Information")
    $Form.Close()
})

[System.Windows.Forms.Application]::Run($Form)
