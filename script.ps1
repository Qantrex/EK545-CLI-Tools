# Ensure the script is run with admin privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as an Administrator." -ForegroundColor Red
    exit
}

# Variables for download URLs (ensure these are updated if needed)
$exaUrl = "https://github.com/ogham/exa/releases/latest/download/exa-win.zip"
$batUrl = "https://github.com/sharkdp/bat/releases/latest/download/bat-x86_64-pc-windows-msvc.zip"
$zoxideUrl = "https://github.com/ajeetdsouza/zoxide/releases/latest/download/zoxide-x86_64-pc-windows-msvc.zip"
$tmuxAltUrl = "https://github.com/zmux/zmux/releases/latest/download/zmux-windows.zip"

# Define installation directory
$installDir = "$HOME\Tools"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

# Helper function for downloading and extracting zip files
function DownloadAndExtract {
    param (
        [string]$url,
        [string]$outputDir
    )
    $tempFile = "$env:TEMP\$(Split-Path $url -Leaf)"
    Invoke-WebRequest -Uri $url -OutFile $tempFile
    Expand-Archive -Path $tempFile -DestinationPath $outputDir -Force
    Remove-Item -Path $tempFile -Force
}

# Download and install tools
Write-Host "Installing exa..." -ForegroundColor Green
DownloadAndExtract -url $exaUrl -outputDir "$installDir\exa"

Write-Host "Installing bat..." -ForegroundColor Green
DownloadAndExtract -url $batUrl -outputDir "$installDir\bat"

Write-Host "Installing zoxide..." -ForegroundColor Green
DownloadAndExtract -url $zoxideUrl -outputDir "$installDir\zoxide"

Write-Host "Installing zmux..." -ForegroundColor Green
DownloadAndExtract -url $tmuxAltUrl -outputDir "$installDir\zmux"

# Add to PATH
$envPathUpdate = "$installDir\exa;$installDir\bat;$installDir\zoxide;$installDir\zmux"
[Environment]::SetEnvironmentVariable("Path", $envPathUpdate + ";" + [Environment]::GetEnvironmentVariable("Path", "User"), "User")

# Set permanent aliases
$profilePath = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

Add-Content -Path $profilePath -Value @"
# Permanent Aliases
Set-Alias cat bat
Set-Alias cd z
Set-Alias ls exa
"@

Write-Host "Permanent aliases added to PowerShell profile."

# Suggest alternative shell and terminal
Write-Host "Installing alternative shell and terminal..." -ForegroundColor Green
Invoke-WebRequest -Uri "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh-windows.zip" -OutFile "$installDir\oh-my-posh.zip"
Expand-Archive -Path "$installDir\oh-my-posh.zip" -DestinationPath "$installDir\oh-my-posh" -Force
Remove-Item -Path "$installDir\oh-my-posh.zip" -Force
Write-Host "Install a terminal like Windows Terminal or Alacritty for enhanced functionality."

Write-Host "Setup complete! Restart PowerShell to apply changes." -ForegroundColor Cyan