# Porting Notes

## Known Required Patches

### Patch 1: Main Bundle Path Resolution

In `.vite/build/main-*.js`, replace app path usage in URL normalization path:

- from: `app.getAppPath()`
- to: `__dirname`

Rationale:

- Prevents path resolution issues in this Windows packaged runtime setup.

### Patch 2: Preload `process` Shim

Append to `.vite/build/preload.js`:

- expose minimal `process` shape in renderer via `contextBridge`
- required fields: `env.NODE_ENV`, `platform`, `cwd()`, `versions`, `type`, `version`

Rationale:

- Renderer bundle references `process.cwd()` in browser context where Node globals are unavailable by default.

## Backend Requirement

- On Windows, backend must be a real executable: `codex.exe`
- Script wrappers (`.cmd`, `.ps1`) are not reliable for direct spawn by app main process.

## Native Module Requirement

At runtime, ensure Windows-compatible native binaries for:

- `better-sqlite3`
- `node-pty`

If extraction contains only macOS binaries, replace/rebuild before launch.

