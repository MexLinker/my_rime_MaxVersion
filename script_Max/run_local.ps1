Param(
  [string]$Proxy,
  [switch]$SkipInstall,
  [switch]$RefreshWorker,
  [int]$Port = 5173
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# One-click local demo runner for My RIME (Windows)
# - Installs dependencies
# - Approves esbuild postinstall
# - Downloads prebuilt worker.js
# - Starts Vite dev server
#
# Examples:
#   .\script_Max\run_local.ps1
#   .\script_Max\run_local.ps1 -Proxy "127.0.0.1:7890"
#   .\script_Max\run_local.ps1 -SkipInstall -Port 5180
#   .\script_Max\run_local.ps1 -RefreshWorker

$ScriptDir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$RepoRoot = Resolve-Path (Join-Path $ScriptDir '..')
Set-Location $RepoRoot

Write-Host "==> Working directory: $RepoRoot" -ForegroundColor Cyan

if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
  Write-Error "pnpm not found. Install it via: npm i -g pnpm"
}

if (-not $SkipInstall) {
  Write-Host "==> Installing dependencies with pnpm..." -ForegroundColor Cyan
  pnpm i
}

Write-Host "==> Approving esbuild postinstall (required by Vite/Rollup)..." -ForegroundColor Cyan
Write-Host "    Command: pnpm approve-builds esbuild" -ForegroundColor DarkGray
try { pnpm approve-builds esbuild } catch { Write-Warning "approve-builds failed or not required: $_" }

$WorkerPath = Join-Path $RepoRoot 'public/worker.js'
$WorkerUrl  = 'https://cdn.jsdelivr.net/npm/@libreservice/my-rime@0.10.9/dist/worker.js'

if ($RefreshWorker -or -not (Test-Path $WorkerPath)) {
  Write-Host "==> Downloading prebuilt worker.js..." -ForegroundColor Cyan
  try {
    Invoke-WebRequest -Uri $WorkerUrl -OutFile $WorkerPath
  } catch {
    Write-Error "Failed to download worker.js from CDN. Consider using -Proxy or check your network. $_"
  }
} else {
  Write-Host "==> Using existing $WorkerPath" -ForegroundColor DarkGray
}

if ($Proxy) {
  Write-Host "==> Setting proxy to $Proxy" -ForegroundColor Cyan
  $env:HTTP_PROXY  = "http://$Proxy"
  $env:HTTPS_PROXY = "http://$Proxy"
  $env:http_proxy  = $env:HTTP_PROXY
  $env:https_proxy = $env:HTTPS_PROXY
}

Write-Host "==> Starting Vite dev server on port $Port..." -ForegroundColor Cyan
Write-Host "    Open http://localhost:$Port/ after server starts." -ForegroundColor DarkGray

pnpm run dev -- --port $Port