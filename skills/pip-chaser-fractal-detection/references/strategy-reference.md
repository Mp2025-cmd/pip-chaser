# Pip Chaser Strategy Reference

This file distills the current PDF strategy for the OpenClaw skill and related workflows.

## Scope

This document defines `Step 1: Detection`.

It is a `fractal detection and alerting` doctrine, not a full trade execution doctrine.

The current bot purpose is:
- scan charts until it sees a fractal
- notify the user through Telegram when a meaningful detection appears

## Timeframes

The PDF says the bot should scan:
- `15 min`
- `1 hour`
- `4 hour`
- `Daily`

## Fractal structure

A fractal is formed from `five consecutive candles`.

### Bullish fractal

The middle candle has the `lowest low` among the five candles.

The two candles before it and the two candles after it must all have `higher lows`.

### Bearish fractal

The middle candle has the `highest high` among the five candles.

The two candles before it and the two candles after it must all have `lower highs`.

## How the PDF says to use fractals

The document describes three main ways fractals help:

### 1. Reversal signals
Fractals can suggest that price may be about to change direction.

### 2. Support and resistance
Fractals can mark levels where price may bounce or break.

### 3. Trend confirmation
The PDF says:
- in an uptrend, a bullish fractal can help confirm continuation
- in a downtrend, a bearish fractal can help confirm continuation

## Breakout interpretation

The PDF includes a breakout interpretation:
- buy when price breaks above a previous bearish fractal in an uptrend
- sell when price breaks below a previous bullish fractal in a downtrend

This is useful as context for later workflows, but the current document still does not define full broker entry or risk-management rules for autonomous execution.

## Indicator context

The screenshot on page 1 shows two TradingView indicators that should be treated as context enhancers, not replacements for the fractal structure.

Indicators visible with confidence:
- `LuxAlgo - Long Wick Detector`
- `Williams Trailing Stops`

Partially readable visible values:
- `LuxAlgo - Long Wick Detector 4 100 50`
- `Williams Trailing Stops 5 9 0 ...`

The tail end of the second indicator settings is not fully readable from the screenshot we extracted, so the skill should not guess any unreadable parameters.

## Detection guidance

A valid detection should be explainable in terms of:
- the fractal direction
- the 5-candle structure
- the timeframe
- nearby support or resistance context
- whether the setup looks more like reversal, breakout, or trend confirmation
- whether indicator context strengthens or weakens confidence

## Weak or invalid detection guidance

Treat the signal as weak when:
- the fractal structure exists but support/resistance is unclear
- the trend context is mixed
- the indicator context is missing or not helpful

Treat the signal as invalid when:
- fewer than five candles are available
- the center candle is not the true extreme
- the timeframe is not one of the supported timeframes
- the context is too incomplete to justify a user alert

## What the current PDF does not define

Do not infer these from this document alone:
- exact trade entry rules
- stop-loss placement
- take-profit logic
- position sizing
- execution timing
- OANDA order behavior

Those belong in later strategy or execution documents, not in this detection skill.

## Suggested Telegram alert style

Alerts should be plain English and cautious.

A good alert should say:
- symbol
- timeframe
- bullish or bearish fractal
- why it is valid
- what weakens confidence, if anything

It should not imply:
- that a live trade has been placed
- that profit targets are known
- that risk rules have already been satisfied
