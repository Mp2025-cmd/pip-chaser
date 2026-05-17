---
name: pip-chaser-fractal-detection
description: Use this skill when evaluating forex chart context for Pip Chaser, especially when the task is to detect, validate, explain, or summarize bullish or bearish fractals on the 15m, 1h, 4h, or Daily timeframe according to the Pip Chaser PDF doctrine.
---

# Pip Chaser Fractal Detection

Use this skill when the user asks Pip Chaser to scan a symbol, validate a detection, explain a fractal, or draft a Telegram alert from chart context.

## What this skill is for

This skill is for `detection only`.

It does:
- identify bullish and bearish fractals
- classify detections as valid, weak, or invalid
- explain why a detection passes or fails
- draft plain-English Telegram alerts

It does not:
- invent trade entries
- invent stop-loss or take-profit levels
- size positions
- trigger broker execution logic

## Core doctrine

A fractal requires `five consecutive candles`.

- `Bullish fractal`: the middle candle has the lowest low of the five candles, and the two candles on each side have higher lows.
- `Bearish fractal`: the middle candle has the highest high of the five candles, and the two candles on each side have lower highs.

Supported timeframes:
- `15m`
- `1h`
- `4h`
- `Daily`

When evaluating a detection, always check:
1. whether the exact 5-candle structure is present
2. whether the timeframe is one of the supported timeframes
3. whether support/resistance context strengthens or weakens the signal
4. whether the signal is better described as reversal, breakout, or trend confirmation
5. whether the visible indicator context strengthens or weakens confidence

## Valid, weak, and invalid outcomes

Mark a detection as `valid` only when:
- the 5-candle pattern is complete
- the middle candle is the correct extreme
- the timeframe is supported
- there is enough surrounding context to explain why the detection matters

Mark a detection as `weak` when:
- the fractal structure exists but support/resistance context is weak
- the fractal structure exists but trend context is mixed
- indicator confirmation is missing or inconclusive

Mark a detection as `invalid` when:
- fewer than 5 candles are available
- the middle candle is not the extreme high or low
- the timeframe is unsupported
- the context is too incomplete to defend the detection

## Explanation style

Keep explanations short, concrete, and plain English.

Always say:
- whether the detection is bullish, bearish, weak, or invalid
- which timeframe you used
- what made the pattern pass or fail
- what missing context still matters

Do not use vague phrases like "looks good" without evidence.

## Output shape

When possible, structure the result around:

```text
valid_detection: true|false
direction: bullish|bearish|none
timeframe: 15m|1h|4h|Daily|unknown
reasoning_summary: short explanation
confirmation_notes: supporting context or weaknesses
telegram_notification_draft: alert-safe summary
missing_information: list or short sentence
```

If information is missing, say so directly instead of guessing.

## References

Read [references/strategy-reference.md](references/strategy-reference.md) when you need the fuller distilled doctrine from the PDF, including:
- the detection purpose
- the fractal definitions
- breakout/reversal/trend-confirmation interpretation
- visible indicator names and partially readable settings
