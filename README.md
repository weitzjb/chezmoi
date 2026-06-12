# Fresh Install Checklist

## Before wiping
- [ ] Confirm iCloud has fully synced — check Desktop and Documents show no spinning icons in Finder
- [ ] Confirm you can see `claude-backup/` and `jo-documents.zip` on icloud.com as a sanity check

## Wipe
- [ ] System Settings → General → Transfer or Reset → Erase All Content and Settings

## Fresh setup
- [ ] Sign in to Apple ID / iCloud during setup wizard
- [ ] Wait for Desktop and Documents to sync down from iCloud
- [ ] Sign in to Mac App Store (needed before chezmoi runs `mas`)

## chezmoi
- [ ] Run: `sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply weitzjb`
- [ ] Sign in to 1Password
- [ ] Run: `chezmoi apply` (renders db-secrets template)

## Restore Claude
- [ ] Copy `~/Desktop/claude-backup/projects/` → `~/.claude/projects/`
- [ ] Copy `~/Desktop/claude-backup/plugins/` → `~/.claude/plugins/`
- [ ] Copy `~/Desktop/claude-backup/history.jsonl` → `~/.claude/`

## Git repos
- [ ] Generate new SSH key, add to GitHub
- [ ] Clone active repos: `picuDashbaord`, `drugCalc2`, `knowledge-pipeline`, `scripts`, `unitdata`

## DEVONthink
- [ ] Wait for CloudKit sync to complete
- [ ] Re-index `~/Documents/notes/` as external folder

## Docker projects
- [ ] `drugCalc2`: copy `.env.example` → `.env`, fill in `POSTGRES_PASSWORD`, `SECRET_KEY`, `ADMIN_EMAIL`, `ADMIN_PASSWORD`
- [ ] `picuDashbaord`: copy `.env.example` → `.env`, fill in DB credentials from 1Password, generate new `FLASK_SECRET_KEY` and password hashes (see comments in `.env.example`)
- [ ] `docker compose up` in `drugCalc2` and `picuDashbaord` to rebuild

## Other users
- [ ] Create user accounts for Ben, Jo, Tom
- [ ] Log in as Jo → unzip `jo-documents.zip` into her Documents

## R projects
- [ ] Run `renv::restore()` in `unitdata` and `reports` on first open
