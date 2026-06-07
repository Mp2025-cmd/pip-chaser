# Pip Chaser Lobster Workflows

This document defines the deterministic workflow layer for Pip Chaser.

Lobster should be used as the ordered workflow shell around small JSON-producing steps. The current OpenClaw docs describe Lobster as a workflow shell for multi-step tool sequences with explicit approval checkpoints and resumable state. They also note that embedded Lobster runs inside the gateway and should avoid nested `openclaw.invoke` patterns for now.

Because of that, these workflows are written as contracts and file scaffolds first. Runtime wiring should use small commands or tools that read and write JSON.

## Workflow Principles

- Inputs and outputs should be JSON.
- Every workflow run must have a `workflow_run_id`.
- Detection workflows must not place broker orders.
- Missing data should return a safe failure, not a guess.
- Telegram alerts should be generated only after validation.
- Side effects should have explicit gates.

## Workflow: `market_scan`

Purpose:
- scan one or more supported symbols/timeframes for candidate fractals

Inputs:
- `symbols`
- `timeframes`
- `requested_by`
- `workflow_run_id`

Steps:
- validate requested symbols and timeframes
- collect or receive normalized candle data
- pass each market context object to `validate_setup`
- collect candidate results
- send only valid/strong alerts to `trade_explain` for Telegram-safe wording

Output:
- list of detection results
- list of skipped symbols/timeframes
- missing-data notes

Safety:
- no broker execution
- no alert if candle data is incomplete
- duplicate alert key must include symbol, timeframe, direction, and center candle timestamp

## Workflow: `validate_setup`

Purpose:
- classify one market context object as valid, weak, or invalid

Inputs:
- one object matching `schemas/market-context.schema.json`

Steps:
- verify supported symbol/timeframe
- verify at least five closed candles
- find candidate bullish/bearish fractal structure
- check support/resistance context
- check Moving Average, RSI, and MACD confirmation notes
- return a structured detection result

Output:
- one object matching `schemas/detection-result.schema.json`

Safety:
- invalid if fewer than five candles are available
- weak if confirmation context is missing
- invalid if timeframe is unsupported

## Workflow: `trade_explain`

Purpose:
- turn a detection result into a Telegram-safe explanation

Inputs:
- one detection result
- requested audience: `dm`, `group`, or `journal`

Steps:
- keep the explanation plain English
- include direction, symbol, timeframe, and classification
- include missing information
- include `detection only`
- explicitly say no trade was placed

Output:
- Telegram-safe message

Safety:
- no entry, stop, target, or position size unless a later strategy document defines them
- never imply execution

## Workflow: `daily_summary`

Purpose:
- summarize detection activity for the team

Inputs:
- date range
- journal entries or workflow results

Steps:
- count scans
- count valid/weak/invalid detections
- list best alerts and why they mattered
- list missing data or failures
- suggest review items

Output:
- short Telegram-ready summary

Safety:
- summary is informational only
- no performance claims without journal evidence

## Deferred Workflow: `paper_trade_execute`

This workflow is intentionally deferred.

It should not exist as an active workflow until:
- exact entry rules exist
- exact stop-loss rules exist
- exact take-profit or exit rules exist
- invalidation rules exist
- OANDA paper credentials are configured
- the safety layer has been tested

## Files

Workflow scaffolds live in:

- `workflows/lobster/market_scan.lobster`
- `workflows/lobster/validate_setup.lobster`
- `workflows/lobster/trade_explain.lobster`
- `workflows/lobster/daily_summary.lobster`

These files are contracts for implementation. They should be wired to real JSON-producing commands once the market-data adapter exists.
