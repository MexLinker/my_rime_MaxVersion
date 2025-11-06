# script_Max

One-click helper to set up and run the My RIME local demo without building WASM or schemas.

## What This Script Does
- Installs project dependencies with `pnpm`.
- Approves `esbuild` postinstall (required by Vite/Rollup).
- Downloads the official prebuilt `public/worker.js` from the CDN so the app can run immediately.
- Optionally sets an HTTP/HTTPS proxy (useful if your network blocks CDN).
- Starts the Vite dev server and prints the local URL.

## Requirements
- macOS or Linux with Node 18+ and `pnpm` 10+.
- Internet access to `cdn.jsdelivr.net` or a working proxy.

## Usage
```sh
chmod +x script_Max/run_local.sh
./script_Max/run_local.sh
```

Options:
- `--proxy HOST:PORT` sets proxy for the current run, e.g. `--proxy 127.0.0.1:7890`.
- `--skip-install` skips `pnpm i` if you already installed dependencies.
- `--refresh-worker` forces redownload of `public/worker.js` from the CDN.
- `--port PORT` sets dev server port (default `5173`).

Examples:
```sh
./script_Max/run_local.sh --proxy 127.0.0.1:7890
./script_Max/run_local.sh --skip-install --port 5180
./script_Max/run_local.sh --refresh-worker
```

### Windows (PowerShell)
Run with PowerShell. If you encounter script policy restrictions, use `-ExecutionPolicy Bypass`.

```powershell
PowerShell -ExecutionPolicy Bypass -File .\script_Max\run_local.ps1
```

Options:
- `-Proxy "127.0.0.1:7890"` sets HTTP/HTTPS proxy for CDN assets.
- `-SkipInstall` skips `pnpm i` if dependencies are already installed.
- `-RefreshWorker` forces redownload of `public/worker.js`.
- `-Port 5180` sets a custom dev server port.

Examples:
```powershell
PowerShell -ExecutionPolicy Bypass -File .\script_Max\run_local.ps1 -Proxy "127.0.0.1:7890"
PowerShell -ExecutionPolicy Bypass -File .\script_Max\run_local.ps1 -SkipInstall -Port 5180
PowerShell -ExecutionPolicy Bypass -File .\script_Max\run_local.ps1 -RefreshWorker
```

## Notes
- This path mirrors what I did: use the CDN-prebuilt worker to avoid a heavy local WASM/toolchain build.
- If you later need an offline build:
  1. Install build tools (`cmake`, `ninja`, `clang-format`) and emscripten.
  2. Run `pnpm run native && pnpm run schema && pnpm run lib && pnpm run wasm`.
  3. Then `pnpm run dev` or `pnpm run build` to produce `dist/`.

## Troubleshooting
- If the input candidates don’t show, your browser may be unable to download runtime or schema assets from the CDN. Use `--proxy 127.0.0.1:7890` or configure a system/browser proxy, then reload.
- Check the browser console/network panel for blocked requests to `@libreservice/my-rime` or `@rime-contrib`.

## Approved Builds Step
The scripts explicitly run the following command to approve `esbuild`’s postinstall step, which downloads platform-specific binaries required by Vite/Rollup:

```sh
pnpm approve-builds esbuild
```

- Why: Some environments or pnpm settings block package build scripts. Approving `esbuild` ensures its binary is available so the dev server and bundler work reliably.
- Where: Both `run_local.sh` and `run_local.ps1` call this and echo the exact command so you can see it in the logs.