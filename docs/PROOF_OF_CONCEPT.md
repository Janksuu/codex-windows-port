# Proof of Concept Evidence

## Build and Runtime

- App version tested: `260205.1301`
- Build number used at launch: `554`
- Electron runtime: `40.0.0`
- Backend: vendored `codex.exe` from global `@openai/codex`

## Observed Startup Indicators

Expected startup lines include:

- `Launching app { ... platform: 'win32', packaged: true }`
- `Initializing Codex CLI connection`
- `Codex CLI initialized`
- Repeated `Received app server result: ...`

## Observed Functional Test

Prompt used:

- `List files in directory`

Observed behavior:

- Assistant executed `Get-ChildItem -Name`
- Returned directory listing without file edits
- Conversation created and remained stable

## Interpretation

This validates C2 (agent smoke test):

- Backend transport works
- Agent request/response loop works
- Terminal command execution path works

## Known Non-Blocking Warnings

- Cache/DIPS warnings in Electron logs
- Missing workspace path warnings for stale or unavailable local paths
- Renderer accessibility warnings from UI components

These do not block basic task execution.

