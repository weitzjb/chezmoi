# Fresh Install Checklist

## Before wiping
- [ ] Confirm iCloud has fully synced — check Desktop and Documents show no spinning icons in Finder

## Wipe
- [ ] System Settings → General → Transfer or Reset → Erase All Content and Settings

## Fresh setup
- [ ] Sign in to Apple ID / iCloud during setup wizard
- [ ] iCloud settings: Desktop & Documents Folders **on**, Passwords **off**, Mail **off** (not chezmoi-managed — these live in an undocumented, account-tied plist, not safe to script)
- [ ] Wait for Desktop and Documents to sync down from iCloud
- [ ] Sign in to Mac App Store (needed before chezmoi runs `mas`)

## chezmoi
- [ ] Run (do **not** prefix with `sudo` — Homebrew's installer refuses to run as root and will prompt for your password itself when needed): `sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply weitzjb/chezmoi` (public repo, no auth needed — this installs Homebrew, 1Password, and everything else in the Brewfile)
- [ ] Sign in to 1Password, now that it's installed (enables SSH agent — GitHub key is already stored there, no need to generate a new one)
- [ ] Run: `chezmoi apply` (renders the 1Password-backed env template)

## Git repos
- [ ] Clone all repos from `weitzjb` into `~/git/`: `dotclaude`, `dailyAssistant`, `picuData`, `drugCalc2`, `appraisalPipeline`, `hcidTraining`, `wpoAdmin`, `jazz-practice` (`dotclaude` first — `~/.claude/skills` links to it)

## DEVONthink
- [ ] Wait for CloudKit sync to complete
- [ ] Re-index `~/Documents/notes/` as external folder

## Docker projects
- [ ] `drugCalc2`: copy `.env.example` → `.env`, fill in `POSTGRES_PASSWORD`, `SECRET_KEY`, `ADMIN_EMAIL`, `ADMIN_PASSWORD`
- [ ] `picuData`: copy `.env.example` → `.env`, fill in DB credentials from 1Password, generate new `FLASK_SECRET_KEY` and password hashes (see comments in `.env.example`)
- [ ] `docker compose up` in `drugCalc2` and `picuData` to rebuild

## VPN
- [ ] Configure Cisco AnyConnect manually — see 1Password for host/group (no longer chezmoi-managed, deliberately)

## Backup
- [ ] Install Backblaze manually via direct download from backblaze.com (no longer a Homebrew cask — installs more reliably direct)

## Other users
- [ ] Create user accounts for Ben, Jo, Tom

## Optional PICU Journal Watch scheduler

During `chezmoi init`, answer **no on the MacBook**, **yes on the Mini** to
“Enable PICU Journal Watch emails on this Mac?”. The answer is stored locally,
not shared between machines. Run `chezmoi apply` to install/enable or disable
the daily 09:00 LaunchAgent. No email is sent by setup itself.

Enabled setup clones dailyAssistant if missing (requires GitHub SSH through
1Password), and uses Homebrew Python without a virtualenv. On a fresh install,
sign into 1Password then rerun apply if cloning was unavailable. Configure personal
Gmail in Apple Mail and approve Mail automation. Existing delivery history is
preserved; otherwise the public initial collection baseline is installed.

For existing machines, run `chezmoi init` once after updating to record the answer.
To change it: `chezmoi edit-config`, change `journalWatchScheduler` under `[data]`,
then `chezmoi apply`. Keep it enabled on only one Mac.
