Param(
  [string]$Proxy,
  [switch]$SkipInstall,
  [switch]$RefreshWorker,
  [int]$Port = 5173,
  [int]$ApiPort = 8787,
  [switch]$NoApi
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# One-click local demo runner for My RIME (Windows)
# - Installs dependencies
# - Approves esbuild postinstall
# - Downloads prebuilt worker.js
# - Starts API server (server/index.ts)
# - Starts Vite dev server
#
# Examples:
#   .\script_Max\run_local.ps1
#   .\script_Max\run_local.ps1 -Proxy "127.0.0.1:7890"
#   .\script_Max\run_local.ps1 -SkipInstall -Port 5180
#   .\script_Max\run_local.ps1 -ApiPort 9000
#   .\script_Max\run_local.ps1 -NoApi
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

if (-not $NoApi) {
  Write-Host "==> Starting API server on port $ApiPort..." -ForegroundColor Cyan
  # Start in background job to keep dev server foreground
  $env:API_PORT = "$ApiPort"
  $apiJob = Start-Job -ScriptBlock { pnpm run api }
  # Simple health check loop (up to ~10s)
  $healthy = $false
  for ($i = 0; $i -lt 20; $i++) {
    try {
      Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:$ApiPort/api/health" -TimeoutSec 2 | Out-Null
      $healthy = $true
      break
    } catch {}
    Start-Sleep -Milliseconds 500
  }
  if ($healthy) { Write-Host "==> API server is healthy." -ForegroundColor DarkGray } else { Write-Warning "API health check did not pass, continuing..." }
  # Stop API on exit
  Register-EngineEvent PowerShell.Exiting -Action { try { Stop-Job -Job $apiJob -Force } catch {} } | Out-Null
}

pnpm run dev -- --port $Port