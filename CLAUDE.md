# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the home directory of James Weitz, a PICU clinician at Oxford John Radcliffe Hospital who builds clinical data tools. All active projects live under `~/git/`. There is no repo at the home-directory level; each project under `~/git/` is its own git repository with its own `CLAUDE.md`.

## Projects

**Active:**

| Directory | Stack | Purpose |
|-----------|-------|---------|
| `~/git/drugCalc2` | Python, FastAPI, WeasyPrint, PostgreSQL, Docker | Drug calculator with database-backed admin UI — current Python version |
| `~/git/picuData` | Python, Plotly Dash, PostgreSQL, Docker | PICU clinical data platform (renamed from `picuDashboard`): ETL + warehouse, Dash dashboard (census, bundle compliance, PICaNet), reports, and source-system docs in `docs/sources/` |
| `~/git/appraisalPipeline` | Python, OpenAI API, AppleScript/JXA | Processes DEVONthink inbox items (appraisal-section tagging) and generates NHS SARD appraisal/CPD narratives at year-end |
| `~/git/hcidTraining` | Python, FastAPI, SQLAlchemy, PostgreSQL, Docker | Internal web app tracking HCID e-learning, fit-testing and practical training compliance for PICU staff |
| `~/git/wpoAdmin` | Python, Django, Docker, Caddy | Committee-only admin app for the Wokingham Philharmonic Orchestra (members, availability, subscriptions, action log) with audit history |
| `~/git/jazz-practice` | Python | Personal adaptive drill tool for jazz-piano practice (intervals, triads, YAML-authored content based on *The Jazz Piano Book*) |
| `~/git/dailyAssistant` | Python, Shell | James's general working seat (daily task triage, ad hoc work via MCP) — also home to the WPO Google Sheets/Gmail CLI, markdown→PDF docs, and the former `~/git/scripts` utilities (now `scripts/`, including journalwatch) |
| `~/git/dotclaude` | Markdown | Personal Claude Code and Codex skills (`sync-repos`, `journal-club`) synced across computers |

Dotfiles live in a separate public repo, `weitzjb/chezmoi`, with its source at `~/.local/share/chezmoi` (not under `~/git/`). This file is managed from it — edit the chezmoi source, not `~/CLAUDE.md`.

**Retired (Nov 2026):** `unitdata`, `unit-analytics`, `clinicalDbDocs`, `icipExport`, `picu-ai-repository` and `dotemacs` have been deleted from GitHub and are no longer cloned under `~/git/`; they are backed up outside GitHub. Source-system documentation from `clinicalDbDocs`/`unit-analytics` now lives in `~/git/picuData/docs/sources/`. Don't expect those repos to exist.

## Key relationships between projects

- `drugCalc2` (Python/FastAPI) is the active drug calculator.
- `picuData` connects to a separate local PostgreSQL data warehouse populated by its own ETL layer; it does **not** read directly from Medicus or CareVue. Reporting and dashboard functionality from the retired `unitdata` repo has moved here; source-system docs are in `docs/sources/`.
- `appraisalPipeline` writes to `~/Documents/appraisal/` (NHS SARD appraisal master doc, PDP/scope-of-work files). It calls the OpenAI API directly — keep the key in `.env` only, not exported to the shell.

## Databases

All clinical databases require VPN. Key sources:

- **Medicus** — PostgreSQL; PICU admission, assessment, diagnosis, discharge, PIM, PCCMDS data
- **CareVue / ICIP** — SQL Server (`CISReportingDB`, `dbo` schema); real-time charting data (VAP/CLABSI bundle compliance, assessments)
- **PICaNet** — PostgreSQL; national audit data

Credentials are in 1Password, injected into the shell at startup via `op inject -i ~/.workenv.tpl`. Docker projects use `.env` files (gitignored). Never committed.

**ICIP_HOST for Docker:** Docker bridge cannot resolve hospital DNS. Use the IP address, not the hostname.

## Docker projects

`drugCalc2` and `picuData` run entirely via `docker compose up`. There is no separate build step for either. Use `docker compose down -v` to reset the database.
