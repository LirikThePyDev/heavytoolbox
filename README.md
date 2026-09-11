# HeavyToolbox 🧰

HeavyToolbox is a comprehensive, portable cybersecurity and penetration testing suite. It consolidates industry-standard security tools, runtimes, and automated scripts into a structured environment for security professionals, researchers, and system administrators.

## 🛠️ Tool Inventory

The toolbox includes pre-configured environments and wrappers for the following components:
* **Reconnaissance & Enumeration:** `nmap`, `ffuf`
* **Exploitation & Post-Exploitation:** `metasploit-framework`, `mimikatz`
* **Traffic Analysis:** `wireshark`
* **Credential Cracking:** `hashcat`
* **Runtime Environment:** Isolated `python` runtime environment

## 🚀 Getting Started

### Prerequisites
* Windows 10/11
* PowerShell 5.1 or higher (run as Administrator for full tool functionality)

### Installation & Usage
1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com
   cd heavytoolbox
   ```
2. Initialize the environment and dependencies by running the installation script in an elevated PowerShell session:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process
   .\install.ps1
   ```
3. Launch the central management console:
   ```cmd
   console.bat
   ```

---

## ⚖️ Disclaimer & Liability Agreement

**PLEASE READ THIS DISCLAIMER CAREFULLY BEFORE USING THE SOFTWARE.**

This repository contains advanced security assessment tools capable of performing network scanning, vulnerability exploitation, credential auditing, and packet analysis. 

### 1. Authorized Use Only
The tools and scripts provided in this repository are intended **strictly for educational purposes, authorized security research, and legitimate penetration testing** on systems where you have explicit, written permission from the owner. 

### 2. Legal Compliance
Unauthorised access, scanning, or exploitation of computer systems is strictly illegal under cybercrime laws globally (such as the US Computer Fraud and Abuse Act or equivalent local legislation). The user assumes all responsibility for complying with applicable local, national, and international laws.

### 3. Limitation of Liability
The creator (`LirikThePyDev`) of this repository:
* Accepts **no liability** and holds **no responsibility** for any misuse, damage, data loss, system downtime, or illegal activity caused by the use or modification of these tools.
* Provides this software on an **"as-is" basis**, without warranties of any kind, express or implied.
* Does not guarantee that these tools are free from false positives, false negatives, or hidden software defects.

**By downloading, cloning, or using this repository, you explicitly agree to these terms and accept full legal accountability for your actions.**
