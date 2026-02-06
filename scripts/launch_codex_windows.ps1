param(
    [string]$AppDir,
    [string]$ElectronPath,
    [string]$CodexCliPath,
    [string]$BuildNumber = "554",
    [string]$BuildFlavor = "prod"
)

$ErrorActionPreference = "Stop"

function Resolve-DefaultCodexCliPath {
    $npmRoot = (npm root -g).Trim()
    if (-not $npmRoot) { return $null }

    $candidate = Join-Path $npmRoot "@openai\codex\vendor\x86_64-pc-windows-msvc\codex\codex.exe"
    if (Test-Path $candidate) { return $candidate }

    $fallback = Get-ChildItem -Recurse -Filter codex.exe (Join-Path $npmRoot "@openai\codex\vendor") -ErrorAction SilentlyContinue |
        Select-Object -First 1 -ExpandProperty FullName
    return $fallback
}

if (-not $AppDir) {
    $AppDir = Join-Path $PSScriptRoot "..\windows_app_260205"
}
if (-not $ElectronPath) {
    $ElectronPath = Join-Path $PSScriptRoot "..\electron\node_modules\.bin\electron.cmd"
}
if (-not $CodexCliPath) {
    $CodexCliPath = Resolve-DefaultCodexCliPath
}

Write-Host "=== Codex Windows Port Launch ==="
Write-Host "AppDir      : $AppDir"
Write-Host "Electron    : $ElectronPath"
Write-Host "Codex CLI   : $CodexCliPath"
Write-Host "BuildNumber : $BuildNumber"
Write-Host "BuildFlavor : $BuildFlavor"
Write-Host ""

if (-not (Test-Path $AppDir)) { throw "App directory not found: $AppDir" }
if (-not (Test-Path $ElectronPath)) { throw "Electron path not found: $ElectronPath" }
if (-not $CodexCliPath -or -not (Test-Path $CodexCliPath)) {
    throw "Codex CLI binary not found. Pass -CodexCliPath explicitly."
}

if (Test-Path Env:ELECTRON_RUN_AS_NODE) { Remove-Item Env:ELECTRON_RUN_AS_NODE }
$env:ELECTRON_RUN_AS_NODE = $null

$env:ELECTRON_FORCE_IS_PACKAGED = "1"
$env:NODE_ENV = "production"
$env:CODEX_CLI_PATH = $CodexCliPath
$env:CODEX_BUILD_NUMBER = $BuildNumber
$env:CODEX_BUILD_FLAVOR = $BuildFlavor
$env:ELECTRON_ENABLE_LOGGING = "1"
$env:SENTRY_DSN = ""
$env:ELECTRON_DISABLE_SANDBOX = "1"

& $ElectronPath $AppDir --enable-logging

