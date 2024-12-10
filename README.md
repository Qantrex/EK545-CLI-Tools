# EK545-CLI-Tools
### **Setup CLI Tools and Aliases Script**

This script installs useful CLI tools (`exa`, `bat`, `zoxide`, `zmux`) on Windows, sets permanent aliases, and configures your CLI environment.

#### **Features**
- Installs `exa` (enhanced `ls`), `bat` (better `cat`), `zoxide` (smart `cd`), and `zmux` (session manager).
- Sets aliases: `ls` → `exa`, `cat` → `bat`, `cd` → `zoxide`.
- Adds tools to the system `PATH`.
- Suggests alternative shell and terminal customization.

#### **Usage**
1. **Clone or download this repository.**
2. **Run the script in PowerShell with admin rights:**
```powershell
   ./setup-cli-tools.ps1
```
3. **Restart PowerShell to apply changes.**

#### **Using the Tools**

- **`exa`**: Replace `ls`. Example: `exa --long`
- **`bat`**: Replace `cat`. Example: `bat file.txt`
- **`zoxide`**: Replace `cd`. Example: `z projects`
- **`zmux`**: Manage sessions.

#### **Optional Customization**

- Install and configure [Oh My Posh](https://ohmyposh.dev) for a better shell prompt.
- Use Windows Terminal or [Alacritty](https://alacritty.org) for an enhanced terminal experience.

