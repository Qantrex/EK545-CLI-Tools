# Ensure the script is run with admin privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as an Administrator." -ForegroundColor Red
    exit
}

# Variables for download URLs (update dynamically if possible)
$urls = @{
    "exa" = "https://github.com/ogham/exa/releases/latest/download/exa-win.zip"
    "bat" = "https://github.com/sharkdp/bat/releases/latest/download/bat-x86_64-pc-windows-msvc.zip"
    "zoxide" = "https://github.com/ajeetdsouza/zoxide/releases/latest/download/zoxide-x86_64-pc-windows-msvc.zip"
    "zmux" = "https://github.com/zmux/zmux/releases/latest/download/zmux-windows.zip"
    "oh-my-posh" = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh-windows.zip"
}

# Define installation directory
$installDir = "$HOME\Tools"
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null
}

# Helper function for downloading and extracting zip files
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

# Download and install tools
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

# Set permanent aliases
$profilePath = $PROFILE
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
DownloadAndExtract -url $urls["oh-my-posh"] -outputDir "$installDir\oh-my-posh"
Write-Host "Consider using Windows Terminal or Alacritty for enhanced functionality."

Write-Host "Setup complete! Restart PowerShell to apply changes." -ForegroundColor Cyan