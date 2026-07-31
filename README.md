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
- [ ] Run: `sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply weitzjb` (public repo, no auth needed — this installs Homebrew, 1Password, and everything else in the Brewfile)
- [ ] Sign in to 1Password, now that it's installed (enables SSH agent — GitHub key is already stored there, no need to generate a new one)
- [ ] Run: `chezmoi apply` (renders db-secrets template via 1Password)

## Restore Claude
- [ ] Copy `~/Desktop/claude-backup/projects/` → `~/.claude/projects/`
- [ ] Copy `~/Desktop/claude-backup/plugins/` → `~/.claude/plugins/`
- [ ] Copy `~/Desktop/claude-backup/history.jsonl` → `~/.claude/`

## Git repos
- [ ] Clone active repos: `picuDashboard`, `drugCalc2`, `knowledge-pipeline`, `scripts`, `jazzPractice`, `WPOAssistant`, `unitdata`

## DEVONthink
- [ ] Wait for CloudKit sync to complete
- [ ] Re-index `~/Documents/notes/` as external folder

## Docker projects
- [ ] `drugCalc2`: copy `.env.example` → `.env`, fill in `POSTGRES_PASSWORD`, `SECRET_KEY`, `ADMIN_EMAIL`, `ADMIN_PASSWORD`
- [ ] `picuDashboard`: copy `.env.example` → `.env`, fill in DB credentials from 1Password, generate new `FLASK_SECRET_KEY` and password hashes (see comments in `.env.example`)
- [ ] `docker compose up` in `drugCalc2` and `picuDashboard` to rebuild

## VPN
- [ ] Configure Cisco AnyConnect manually — host `vpn.oxnet.nhs.uk`, group `OxNET` (no longer chezmoi-managed, deliberately)

## Other users
- [ ] Create user accounts for Ben, Jo, Tom
- [ ] Log in as Jo → unzip `jo-documents.zip` into her Documents

## R projects
- [ ] Run `renv::restore()` in `unitdata` on first open
