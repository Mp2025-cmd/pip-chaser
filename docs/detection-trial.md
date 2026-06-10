# Pip Chaser Detection Trial

Milestone 9 is the learning phase.

The bot is allowed to scan live OANDA demo candle data, classify fractal detections, journal every result, and create summaries for review. It is still not allowed to place trades.

## Trial Goal

The goal is to answer a simple question:

Can Pip Chaser detect and explain fractal setups consistently enough that we trust the detection layer before adding any execution logic?

## What Runs

Run a market scan:

```bash
./bin/pip-chaser workflows market-scan --journal
```

Run a smaller scan:

```bash
./bin/pip-chaser workflows market-scan --symbols EUR_USD --timeframes 15m,1h --journal
```

Preview Telegram signal delivery without sending:

```bash
./bin/pip-chaser workflows market-scan --journal --send-telegram --dry-run
```

Send valid signals to the approved Telegram group:

```bash
./bin/pip-chaser workflows market-scan --journal --send-telegram
```

The VPS scheduler runs the same scan every 15 minutes for:

- `XAU_USD`
- `EUR_USD`
- `GBP_USD`
- `USD_JPY`
- `15m`
- `1h`

Scheduled scans request 80 candles per symbol/timeframe so EMA 20/50, RSI 14, and MACD 12/26/9 have enough history.
Telegram delivery is rate-limited to one alert per scan, with a 240-minute cooldown per pair/timeframe/direction.

Review the journal:

```bash
./bin/pip-chaser journal list --limit 20
```

Create the daily review summary:

```bash
./bin/pip-chaser workflows daily-summary
```

## What The Scan Does

The scan checks the v1 symbols and timeframes:

- `EUR_USD`
- `GBP_USD`
- `USD_JPY`
- `XAU_USD`
- `15m`
- `1h`
- `4h`
- `Daily`

For each pair/timeframe it:

- pulls OANDA demo candles
- retries transient OANDA read failures before marking a scan as failed
- normalizes the data
- computes first-pass support/resistance from recent swing pivots
- computes EMA 20/50, RSI 14, and MACD 12/26/9 confirmation
- detects the most recent complete 5-candle fractal
- marks the setup as `valid`, `weak`, or `invalid`
- flags duplicate alerts using symbol, timeframe, direction, and center candle timestamp
- sends Telegram alerts only for non-duplicate `valid` detections when delivery is enabled
- writes workflow and setup-decision entries to the local journal

## Signal Delivery

Signal delivery uses the Telegram Bot API directly.

Required local environment variables:

```bash
TELEGRAM_BOT_TOKEN=your-telegram-bot-token
TELEGRAM_SIGNAL_CHAT_ID=your-approved-group-chat-id
```

Delivery rules:

- `valid` detections are sent.
- `weak` detections are journaled but skipped.
- `invalid` detections are journaled but skipped.
- duplicate detections are journaled but skipped.
- every sent, skipped, dry-run, or failed delivery is journaled
- `--send-telegram` requires `--journal`

## How To Review Results

Look for:

- valid detections that make sense on the chart
- weak detections that should become valid once indicator context is added
- invalid results that correctly rejected bad setups
- duplicate alerts that should not be sent repeatedly
- explanations that are clear enough for the Telegram group
- failures from OANDA, missing data, or runtime issues

## Trial Rules

- Detection only.
- No OANDA orders.
- No entry, stop-loss, take-profit, or position sizing.
- No live cash credentials.
- Every scan should be journaled.
- Telegram delivery should be tested with `--dry-run` before real sending.
- Any confusing alert should become a review note before tuning the skill or workflow.

## Exit Criteria

Milestone 9 is complete only after the team has reviewed real scan history and can say:

- the scanner runs reliably
- duplicate alerts are controlled
- explanations are understandable
- false positives and missed detections are being tracked
- the next tuning steps are clear
