# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the home directory of James Weitz, a PICU clinician at Oxford John Radcliffe Hospital who builds clinical data tools. All active projects live under `~/git/`. There is no repo at the home-directory level; each project under `~/git/` is its own git repository with its own `CLAUDE.md`.

## Projects

| Directory | Stack | Purpose |
|-----------|-------|---------|
| `~/git/drugcalc` | TypeScript, Node.js, Playwright | Emergency drug chart PDF generator (current version) |
| `~/git/drugCalcPython` | Python, FastAPI, WeasyPrint, PostgreSQL, Docker | Earlier Python version of the same drug calculator with admin UI |
| `~/git/picuDashboard` | Python, Plotly Dash, PostgreSQL, Docker | Clinical dashboard for PICU metrics (census, bundle compliance, PICaNet) |
| `~/git/reports` | R, Quarto, renv | Annual CIC report pipeline: extracts KPIs from Medicus/CareVue and renders Word docs |
| `~/git/unitdata` | R, Quarto, renv | Multi-project clinical data pipeline; active project is PICaNet State of Nations (`Projects/cec2026/`) |
| `~/.local/share/chezmoi` | chezmoi | Dotfiles — GitHub: `git@github.com:weitzjb/chezmoi.git` |
| `~/git/scripts` | R, Shell, AppleScript | One-off utility scripts |

## Key relationships between projects

- `drugcalc` (TypeScript) and `drugCalcPython` are two implementations of the same drug calculator product. The Python version has a database-backed admin API; the TypeScript version is simpler and currently active.
- `reports` and `unitdata` both connect to the same databases (Medicus/PostgreSQL, CareVue/SQL Server). `reports` produces the annual CIC committee documents; `unitdata` powers ad-hoc analysis and the PICANet state-of-nations report.
- The SNOMED diagnosis lookup in `reports/data/end_diagnosis_snomed_lookup.csv` is referenced by `unitdata` — keep in sync when refreshing.
- `picuDashboard` connects to a separate local PostgreSQL data warehouse populated by its own ETL layer; it does **not** read directly from Medicus or CareVue.

## Databases

All clinical databases require VPN. Key sources:

- **Medicus** — PostgreSQL; PICU admission, assessment, diagnosis, discharge, PIM, PCCMDS data
- **CareVue / ICIP** — SQL Server (`CISReportingDB`, `dbo` schema); real-time charting data (VAP/CLABSI bundle compliance, assessments)
- **PICaNet** — PostgreSQL; national audit data

Credentials are in 1Password, injected into the shell at startup via `op inject -i ~/.db-secrets.env.tpl`. R projects inherit them from the shell; Docker projects use `.env` files (gitignored). Never committed.

**ICIP_HOST for Docker:** Docker bridge cannot resolve hospital DNS. Use the IP address, not the hostname.

## R environment notes

Both `reports` and `unitdata` use `renv`. Always run `renv::restore()` on a fresh clone. Render Quarto documents from the **project root** — rendering from a subdirectory breaks `here()`. Don't add `library()` calls for packages already loaded by `startup.R` (double-loading compiled packages can segfault on macOS).

## Docker projects

`drugCalcPython` and `picuDashboard` run entirely via `docker compose up`. There is no separate build step for either. Use `docker compose down -v` to reset the database.
