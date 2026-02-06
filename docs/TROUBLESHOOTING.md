# Troubleshooting

## Backend Does Not Start

Symptoms:

- `Unable to locate the Codex CLI binary`
- `Failed to spawn Codex CLI`

Fix:

- Set `CODEX_CLI_PATH` to actual `codex.exe`, not `.cmd`.
- Verify path exists and is executable.

## Renderer Error About `process`

Symptoms:

- `process is not defined`
- `process.cwd is not a function`

Fix:

- Ensure preload exposes a minimal `process` object via `contextBridge`.
- Use a direct function wrapper for `cwd`, not an unsafe binding pattern.

## Native Module ABI/Platform Issues

Symptoms:

- `.node` load failures
- startup crashes involving sqlite or pty

Fix:

- Ensure Windows-native binaries for `better-sqlite3` and `node-pty`.
- If rebuild from extracted tree fails, copy known-good Windows module trees from prior working build.

## Repeated Git Workspace Errors

Symptoms:

- `failed to list worktrees`
- `path does not exist`

Fix:

- Remove invalid workspace entries from app settings/workspace list.
- Re-open valid project roots only.

## `ERR_FILE_NOT_FOUND` Spam

Likely causes:

- Missing local asset references after hashed asset drift
- stale routes/resources in app state

Fix:

- Recheck extraction completeness.
- Verify `.vite/build/main.js` points to existing `main-*.js`.
- Clear app state cache and relaunch.

