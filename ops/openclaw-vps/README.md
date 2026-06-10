# OpenClaw VPS Setup

This folder contains the first implementation artifacts for Milestone 1:

- a Linux VPS deployment runbook
- a bootstrap script for installing OpenClaw
- a hosted Telegram/OpenClaw checklist

The goal of Milestone 1 is not to build the trading strategy yet. It is to get the always-on OpenClaw runtime online on a Linux VPS, connect Telegram, and keep the environment paper-trading-only from day one.

## Recommended Milestone 1 approach

Use the standard OpenClaw install flow on a Linux VPS first.

Why:
- it is the officially recommended install path
- it keeps the first deployment simpler than jumping straight into a custom Docker stack
- it gives us a working runtime quickly for Telegram and later skill/workflow loading

Use Docker only if you specifically want the gateway containerized from the start.

## What this milestone should achieve

By the end of Milestone 1 we should have:
- a Linux VPS
- OpenClaw installed and running as a managed service
- Telegram connected to OpenClaw
- an LLM provider configured
- paper-only environment separation in place
- basic health checks passing

## Files in this folder

- `bootstrap-openclaw.sh`
  - installs system packages and OpenClaw
  - verifies the CLI is available
  - does not store secrets
- `CHECKLIST.md`
  - step-by-step operational checklist for bringing the VPS online
- command-triggered alert instructions
  - show how OpenClaw should start one OANDA demo scan after an approved Telegram command

## Notes from the official OpenClaw docs

These choices follow the current official docs:
- the installer script is the recommended install path
- Linux supports managed startup via a systemd user service
- Telegram can be added with `openclaw channels add --channel telegram --token "<token>"`
- install verification should include:
  - `openclaw --version`
  - `openclaw doctor`
  - `openclaw gateway status`

## Not in scope for Milestone 1

Milestone 1 does not yet include:
- the PDF strategy skill
- Lobster workflow implementation
- OANDA execution wiring
- live-money credentials

Those come after the hosted OpenClaw runtime is in place.

## Command-Triggered Signal Scanner

The demo signal scanner should be started from Telegram commands through OpenClaw.

Current product mode:
- no autonomous scheduled alerts
- no systemd timer
- only the owner or Derek Ngwu can start signal delivery
- one alert max per command-triggered scan
- 240-minute cooldown per pair/timeframe/direction

Runtime command for OpenClaw to run after an approved `/scan` request:

```bash
cd /opt/pip-chaser
set -a
. /etc/pip-chaser/pip-chaser.env
set +a
/opt/pip-chaser/bin/pip-chaser alerts run \
  --requested-by-telegram-id "<owner-or-derek-telegram-id>" \
  --symbols XAU_USD,EUR_USD,GBP_USD,USD_JPY \
  --timeframes 15m,1h
```

Telegram delivery is intentionally conservative: one alert per command-triggered scan, and no repeated alert for the same pair/timeframe/direction for 240 minutes.

Secrets live only on the VPS:

```bash
/etc/pip-chaser/pip-chaser.env
```

Required keys:

```bash
OANDA_PAPER_API_KEY=
OANDA_PAPER_API_BASE=https://api-fxpractice.oanda.com
TELEGRAM_BOT_TOKEN=
TELEGRAM_SIGNAL_CHAT_ID=
PIP_CHASER_ALERT_ALLOWED_TELEGRAM_IDS=
```
