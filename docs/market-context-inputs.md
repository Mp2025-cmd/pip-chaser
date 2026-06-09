# Pip Chaser Market Context Inputs

This document defines the minimum market context Pip Chaser needs before a workflow can validate a fractal detection.

The current system is still `detection only`. Market context exists to help the bot classify and explain setups, not to place trades.

## V1 Symbols

Start with a small forex set:

- `EUR_USD`
- `GBP_USD`
- `USD_JPY`
- `XAU_USD`

Reason:
- they are liquid major pairs
- they are easy to recognize in OANDA-style instrument format
- gold is included because the team is actively testing XAU/USD from Telegram
- they are enough to test detection quality without creating alert noise

Additional pairs can be added after the detection trial.

## V1 Timeframes

Use only the strategy-supported timeframes:

- `15m`
- `1h`
- `4h`
- `Daily`

Internal mapping:

- `15m` -> `M15`
- `1h` -> `H1`
- `4h` -> `H4`
- `Daily` -> `D`

If a user asks for another timeframe, the bot should explain that it is unsupported.

## Candle Requirements

A fractal needs five consecutive candles.

The workflow should request more than five candles so it can evaluate surrounding context:

- minimum: `21` candles
- preferred: `50` candles

Each candle must include:

- timestamp
- open
- high
- low
- close
- volume if available
- complete/closed-candle flag

The bot should only validate fractals on closed candles.

## Confirmation Context

The strategy currently asks for confirmation using:

- support/resistance context around the fractal
- Moving Averages for trend filtering
- RSI for momentum confirmation
- MACD for momentum confirmation

These values may come from:

- automatic swing-pivot calculation from OANDA candles
- precomputed market-data tooling
- TradingView screenshots/manual context
- later OANDA/indicator adapter code

If confirmation values are missing, the setup can still be described, but confidence should be downgraded to weak or incomplete.

Current automatic defaults:
- EMA 20/50 for trend confirmation
- RSI 14 for momentum confirmation
- MACD 12/26/9 for momentum confirmation

## Automatic Support/Resistance

The OANDA adapter computes a first-pass support/resistance context from closed candles.

Current method:
- find recent swing lows as support candidates
- find recent swing highs as resistance candidates
- compare the latest fractal center price against the nearest relevant level
- treat bullish fractals as stronger near support
- treat bearish fractals as stronger near resistance

This is intentionally simple. It is good enough for v1 signal filtering, but the team should still review charts during the detection trial.

## Chart Images

Chart images are optional in v1.

Default:
- do not require chart images
- use structured candle data first
- allow chart screenshots as extra context when a user posts them

Reason:
- structured candles are easier to validate consistently
- screenshots can be ambiguous or incomplete
- chart-image support can be added after the data workflow is stable

## Market Context Input Shape

The canonical validation input should include:

- `symbol`
- `timeframe`
- `candles`
- `trend_context`
- `indicator_context`
- `support_resistance_context`
- `source`
- `requested_by`
- `workflow_run_id`

The JSON Schema lives in:

- `schemas/market-context.schema.json`

## Data Source Boundary

The preferred source for candles is OANDA practice/demo because OANDA is already the planned paper-trading broker boundary.

Current adapter:
- `bin/pip-chaser market-context collect`
- `bin/pip-chaser market-context price`
- reads from OANDA practice/demo only
- requires `OANDA_PAPER_API_KEY`
- returns normalized market-context JSON
- returns a latest closed-candle quote for quick price checks
- computes first-pass support/resistance context from closed candles
- does not place trades

The adapter should return normalized candle JSON and should not make trading decisions.

OANDA setup notes live in:

- `docs/oanda-demo-data.md`

## Reusable Tool Decision

Prefer reusable tools if they can produce clean candle JSON.

Accept a tool when it:
- supports the selected symbols
- supports `15m`, `1h`, `4h`, and `Daily`
- returns closed candles
- has predictable timestamps
- can run on the VPS without UI automation
- does not mix broker execution with market-data reads

Reject a tool when it:
- only returns screenshots
- cannot separate paper/live credentials
- requires manual browser sessions for routine scans
- returns inconsistent candle shapes
- adds strategy decisions outside the fractal skill

## Missing Data Behavior

If market data is missing or incomplete, the bot should not guess.

Safe reply:

```text
I do not have enough candle data to validate this setup.

Need: at least 5 closed candles on a supported timeframe, plus trend and confirmation context for a stronger read.
```
