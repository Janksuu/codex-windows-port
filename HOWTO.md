# How-To (Sanitized)

## 1. Prepare Inputs

- Extract the Codex `.dmg` into an app payload folder.
- Confirm payload has `package.json`, `.vite/build`, `webview`, and `node_modules`.

Example placeholders:

- App payload: `<APP_PAYLOAD_DIR>`
- Electron runtime: `<ELECTRON_DIR>\node_modules\.bin\electron.cmd`

## 2. Configure Backend CLI

Install CLI:

```powershell
npm i -g @openai/codex
```

Find vendored backend binary:

```powershell
Get-ChildItem -Recurse -Filter codex.exe "$(npm root -g)\@openai\codex\vendor"
```

Use the `x86_64-pc-windows-msvc` binary on standard x64 Windows.

## 3. Apply Port Patches

Patch A (main bundle):

- In `.vite/build/main-*.js`, replace `app.getAppPath()` usage in URL normalization path with `__dirname`.

Patch B (preload):

- In `.vite/build/preload.js`, expose a minimal `process` shim via `contextBridge` for renderer code that calls `process.cwd()`.

## 4. Native Modules

At minimum, ensure Windows-compatible modules for:

- `better-sqlite3`
- `node-pty`

If direct rebuild fails due partial extraction trees, use known-good Windows module trees from a previously working build as a carry-forward strategy.

## 5. Launch

Use `scripts/launch_codex_windows.ps1` and pass explicit paths:

```powershell
.\scripts\launch_codex_windows.ps1 `
  -AppDir "<APP_PAYLOAD_DIR>" `
  -ElectronPath "<ELECTRON_CMD_PATH>" `
  -CodexCliPath "<CODEX_EXE_PATH>" `
  -BuildNumber "554"
```

## 6. Smoke Test

In app chat, run:

- `List files in this directory`

Success criteria:

- Backend initializes.
- Conversation is created.
- Command executes and output returns in UI.

## 7. Upgrade Workflow

For each new upstream app version:

1. Extract new payload.
2. Run compare script for drift.
3. Re-apply two known patches.
4. Validate native modules.
5. Repeat smoke test.

