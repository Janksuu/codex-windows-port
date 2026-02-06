# Codex Desktop Windows Port (Proof of Concept)

Unofficial educational proof of concept for running the current macOS Codex desktop app payload on Windows using Electron.

## Scope

- Goal: launch app, connect backend, run basic agent task on Windows.
- This is a reverse-engineering and compatibility exercise, not an official release.
- No OpenAI proprietary app payload or binaries are redistributed here.

## Status

- Checkpoint C0: app launches on Windows.
- Checkpoint C1: renderer UI loads.
- Checkpoint C2: backend connects and executes a basic task.
- Next: C3/C4 worktree and file operation validation.

## Tested Target

- App version: `260205.1301`
- Build number: `554`
- Electron runtime: `40.0.0`
- Backend source: `@openai/codex` vendored `codex.exe`

## What This Repo Contains

- Sanitized setup and launch instructions.
- Reusable scripts (launch, compare, leakage scan).
- Technical notes and troubleshooting.

## What This Repo Does Not Contain

- Extracted Codex desktop application files.
- `app.asar` contents from OpenAI distribution.
- Vendored backend binaries.
- Personal machine-specific logs or identity data.

## Prerequisites

- Windows 10/11 x64
- Node.js + npm
- 7-Zip
- Local Electron 40 runtime
- A legal local copy of the Codex macOS app payload (for your own extraction)
- `npm i -g @openai/codex`

## Quick Start

1. Prepare your extracted app payload in your own workspace.
2. Use `scripts/launch_codex_windows.ps1` with your paths.
3. Confirm startup and run a smoke prompt: `List files in this directory`.

See `HOWTO.md` for full steps.

## Legal and Safety

- Unofficial and not affiliated with OpenAI.
- Respect OpenAI terms and local law.
- Publish only scripts/docs/patch notes, never proprietary payload files.

## License

- MIT for original content in this repository (docs, scripts, and notes).
- This license does not apply to third-party or proprietary software referenced by this workflow (including OpenAI app payloads and binaries).

