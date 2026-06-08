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
- `15m`
- `1h`
- `4h`
- `Daily`

For each pair/timeframe it:

- pulls OANDA demo candles
- normalizes the data
- detects the most recent complete 5-candle fractal
- marks the setup as `valid`, `weak`, or `invalid`
- flags duplicate alerts using symbol, timeframe, direction, and center candle timestamp
- writes workflow and setup-decision entries to the local journal

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
- Any confusing alert should become a review note before tuning the skill or workflow.

## Exit Criteria

Milestone 9 is complete only after the team has reviewed real scan history and can say:

- the scanner runs reliably
- duplicate alerts are controlled
- explanations are understandable
- false positives and missed detections are being tracked
- the next tuning steps are clear

