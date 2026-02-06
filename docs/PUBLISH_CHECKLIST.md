# Publish Checklist

## Include

- `README.md`
- `HOWTO.md`
- `scripts/*.ps1`
- `docs/*.md`

## Exclude

- Extracted app payload directories
- Any `.dmg` files
- Raw app logs with local identities
- Chat transcripts containing local machine paths
- `node_modules` and built binaries

## Privacy Validation

Run before publish:

```powershell
.\scripts\scan_sensitive.ps1 -Root .
```

Review and ensure zero hits for:

- local usernames
- absolute local paths
- email addresses
- tokens/keys/secrets

## Legal Validation

- No proprietary payload content committed
- No redistributed `codex.exe` or OpenAI app binaries
- Repo framed as educational/research proof-of-concept

