<#
.SYNOPSIS
This script installs several command-line tools (exa, bat, zoxide, zmux, oh-my-posh) on a Windows system and configures the environment for enhanced shell usability.

.DESCRIPTION
The script automates the process of downloading, extracting, and installing popular command-line tools. It ensures:
1. The script is run as an Administrator.
2. Tools are downloaded to a designated directory (`$HOME\Tools`).
3. The PATH environment variable is updated.
4. PowerShell aliases are added to streamline usage.
5. Recommendations for alternative terminals are provided.

.REQUIREMENTS
- Administrator privileges.
- PowerShell 5.1 or later.
- Internet connection for downloading tool archives.

.OUTPUTS
Console messages indicating progress and completion of the setup process.

.NOTES
- If the script fails during any step, appropriate error messages will be displayed.
- After running the script, restart your PowerShell session to apply changes.

.AUTHOR
Konstantin Bauer

.LAST UPDATED
2024-12-10
#>

# Ensure the script is run as an Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as an Administrator." -ForegroundColor Red
    exit
}

# URLs for downloading tools
$urls = @{
    "exa" = "https://github.com/ogham/exa/releases/latest/download/exa-win.zip"
    "bat" = "https://github.com/sharkdp/bat/releases/latest/download/bat-x86_64-pc-windows-msvc.zip"
    "zoxide" = "https://github.com/ajeetdsouza/zoxide/releases/latest/download/zoxide-x86_64-pc-windows-msvc.zip"
    "zmux" = "https://github.com/zmux/zmux/releases/latest/download/zmux-windows.zip"
    "oh-my-posh" = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh-windows.zip"
}

# Installation directory
$installDir = "$HOME\Tools"
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null
}

# Function to download and extract files
function DownloadAndExtract {
    param (
        [string]$url,
        [string]$outputDir
    )
    try {
        $fileName = Split-Path $url -Leaf
        $tempFile = "$env:TEMP\$fileName"
        Write-Host "Downloading $fileName..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $url -OutFile $tempFile -ErrorAction Stop
        Write-Host "Extracting $fileName..." -ForegroundColor Yellow
        Expand-Archive -Path $tempFile -DestinationPath $outputDir -Force
        Remove-Item -Path $tempFile -Force
    } catch {
        Write-Host "Error downloading or extracting $url: $_" -ForegroundColor Red
    }
}

# Download and install each tool
foreach ($tool in $urls.Keys) {
    Write-Host "Installing $tool..." -ForegroundColor Green
    DownloadAndExtract -url $urls[$tool] -outputDir "$installDir\$tool"
}

# Update PATH environment variable
$envPaths = @("$installDir\exa", "$installDir\bat", "$installDir\zoxide", "$installDir\zmux")
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$updatedPath = ($currentPath + ";" + ($envPaths -join ";")).TrimEnd(';')
[Environment]::SetEnvironmentVariable("Path", $updatedPath, "User")
Write-Host "Updated PATH environment variable." -ForegroundColor Green

# Configure PowerShell profile
$profilePath = $PROFILE
if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

Add-Content -Path $profilePath -Value @"
Set-Alias cat bat
Set-Alias cd z
Set-Alias ls exa
"@
Write-Host "Permanent aliases added to PowerShell profile."

# Install oh-my-posh (alternative shell)
Write-Host "Installing alternative shell and terminal..." -ForegroundColor Green
DownloadAndExtract -url $urls["oh-my-posh"] -outputDir "$installDir\oh-my-posh"
Write-Host "Consider using Windows Terminal or Alacritty for enhanced functionality."

# Completion message
Write-Host "Setup complete! Restart PowerShell to apply changes." -ForegroundColor Cyan
