# HeavyToolbox 🧰

```text
  _    _                           _______            _ _box 

 | |  | |                         |__   __|          | | |    
 | |__| | ___  __ ___   ___   _      | | ___   ___  | | |__  ___  __  __
 |  __  |/ _ \/ _` \ \ / / | | |     | |/ _ \ / _ \ | | '_ \/ _ \ \ \/ /
 | |  | |  __/ (_| |\ V /| |_| |     | | (_) | (_) || | |_) | (_) | >  < 
 |_|  |_|\___|\__,_| \_/  \__, |     |_|\___/ \___/ |_|_.__/\___/ /_/\_\
                           __/ |                                        
                          |___/                                         
```

HeavyToolbox is an automated, portable cybersecurity orchestration console for Windows. It spins up a completely isolated, environment-aware workspace that dynamically maps industry-standard penetration testing tools into a localized sub-shell—without altering your system's permanent environment variables or cluttering your path profile.

---

## 🚀 One-Command Deployment

Open PowerShell as **Administrator** and run this single pipeline to clone the framework and launch the automation wizard instantly:

```powershell
git clone https://github.com; cd heavytoolbox; .\console.bat
```
*(Inside the orchestrator menu interface, select option **11. Run All Installers** to watch the Win32 graphical setup wizard dynamically configure your environment).*

---

## 🛠️ Integrated Orchestrator Menu
The central console provides rapid, customized execution wrappers for:
1. **Python Shell** - Embedded, un-isolated programming runtime
2. **Mapped Sub-shell** - Spawns a custom CLI pre-mapped with all tool paths
3. **Nmap** - Automated vulnerability scanning and network discovery
4. **Ffuf** - High-speed web fuzzing and directory brute-forcing
5. **Netcat** - Port listening and raw shell catching
6. **Tshark (Wireshark)** - Command-line packet capture and stream analysis
7. **Metasploit Framework** - Full exploitation console access environment
8. **MSFvenom Wizard** - Step-by-step interactive payload generation
9. **Mimikatz** - Active privilege auditing wrapper *(Requires Admin)*
10. **Sysinternals Prompt** - Rapid sandbox access to PsExec, ProcDump, and AccessChk

---

## 📢 Community Driven: Shaped By You!
HeavyToolbox is built to be a living, evolving ecosystem. **This project will be continuously updated and expanded based entirely on user preferences, community requests, and tool recommendations.** 

* **Want a new tool added?** Open an Issue with your favorite tool name.
* **Have a custom automation script?** Submit a Pull Request.
* **Want a specific menu feature?** Let us know in the repository discussions.

---

## ⚖️ Disclaimer & Liability Agreement

This repository contains advanced security assessment tools capable of performing network scanning, vulnerability exploitation, credential auditing, and packet analysis. 

### 1. Authorized Use Only
The tools and scripts provided in this repository are intended **strictly for educational purposes, authorized security research, and legitimate penetration testing** on systems where you have explicit, written permission from the owner. 

### 2. Legal Compliance
Unauthorised access, scanning, or exploitation of computer systems is strictly illegal under cybercrime laws globally. The user assumes all responsibility for complying with applicable local, national, and international laws.

### 3. Limitation of Liability
The creator (`LirikThePyDev`) of this repository accepts **no liability** and holds **no responsibility** for any misuse, damage, data loss, system downtime, or illegal activity caused by the use or modification of these tools. This software is provided on an **"as-is" basis**, without warranties of any kind.
