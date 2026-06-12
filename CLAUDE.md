# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the home directory of James Weitz, a PICU clinician at Oxford John Radcliffe Hospital who builds clinical data tools. All active projects live under `~/git/`. There is no repo at the home-directory level; each project under `~/git/` is its own git repository with its own `CLAUDE.md`.

## Projects

**Active:**

| Directory | Stack | Purpose |
|-----------|-------|---------|
| `~/git/drugCalc2` | Python, FastAPI, WeasyPrint, PostgreSQL, Docker | Drug calculator with database-backed admin UI — current Python version |
| `~/git/picuDashbaord` | Python, Plotly Dash, PostgreSQL, Docker | Clinical dashboard for PICU metrics (census, bundle compliance, PICaNet) — note typo in dir name |
| `~/git/knowledge-pipeline` | Python, Anthropic API, AppleScript/JXA | AI-assisted knowledge management: processes DEVONthink inbox items (tagging, library writes, appraisal entries) and generates NHS SARD appraisal narratives at year-end |
| `~/git/scripts` | R, Shell, AppleScript | One-off utility scripts |

**Redundant / historical (kept for reference):**

| Directory | Status | Notes |
|-----------|--------|-------|
| `~/git/drugCalc` | Superseded | TypeScript/Node.js drug calculator; simpler than `drugCalc2`; remote on Bitbucket |
| `~/git/drug-calculator` | Superseded | Older Python/Flask drug calculator; superseded by `drugCalc2` |
| `~/git/unitdata` | Winding down | R/Quarto clinical data pipeline; PICaNet State of Nations work; now on GitHub |
| `~/git/reports` | Winding down | R/Quarto annual CIC report pipeline; reporting moving into `picuDashbaord` |
| `~/git/dot` | Historical | Old dotfiles (Shell, Emacs Lisp); replaced by chezmoi |

## Key relationships between projects

- `drugCalc2` (Python/FastAPI) is the active drug calculator. `drugCalc` (TypeScript, Bitbucket) and `drug-calculator` (Flask) are older versions kept for reference only.
- `picuDashbaord` connects to a separate local PostgreSQL data warehouse populated by its own ETL layer; it does **not** read directly from Medicus or CareVue. Reporting and dashboard functionality from `reports` and `unitdata` is migrating here.
- `knowledge-pipeline` writes to `~/notes/library/` (plain markdown, indexed by DEVONthink) and `~/notes/appraisal/` (NHS SARD appraisal master doc). It calls the Anthropic API directly — keep the key in `.env` only, not exported to the shell.
- Dotfiles are managed by **chezmoi** (separate workflow); `~/git/dot` is a historical repo kept for reference.

## Databases

All clinical databases require VPN. Key sources:

- **Medicus** — PostgreSQL; PICU admission, assessment, diagnosis, discharge, PIM, PCCMDS data
- **CareVue / ICIP** — SQL Server (`CISReportingDB`, `dbo` schema); real-time charting data (VAP/CLABSI bundle compliance, assessments)
- **PICaNet** — PostgreSQL; national audit data

Credentials are in 1Password, injected into the shell at startup via `op inject -i ~/.db-secrets.env.tpl`. R projects inherit them from the shell; Docker projects use `.env` files (gitignored). Never committed.

**ICIP_HOST for Docker:** Docker bridge cannot resolve hospital DNS. Use the IP address, not the hostname.

## R environment notes

`reports` and `unitdata` use `renv`. Always run `renv::restore()` on a fresh clone. Render Quarto documents from the **project root** — rendering from a subdirectory breaks `here()`. Don't add `library()` calls for packages already loaded by `startup.R` (double-loading compiled packages can segfault on macOS).

## Docker projects

`drugCalc2` and `picuDashbaord` run entirely via `docker compose up`. There is no separate build step for either. Use `docker compose down -v` to reset the database.
