# OANDA Demo Candle Data

Pip Chaser can use OANDA demo/practice data as the first live market-data source.

This is read-only market data. It does not place trades.

## Official API Shape

OANDA practice base URL:

- `https://api-fxpractice.oanda.com`

Candles endpoint:

- `GET /v3/instruments/{instrument}/candles`

The adapter uses midpoint candles:

- `price=M`

Timeframe mapping:

- `15m` -> `M15`
- `1h` -> `H1`
- `4h` -> `H4`
- `Daily` -> `D`

## Environment Variables

Set this on the VPS or local shell:

```bash
export OANDA_PAPER_API_KEY="your-demo-token"
```

Optional override:

```bash
export OANDA_PAPER_API_BASE="https://api-fxpractice.oanda.com"
```

Do not commit API keys.

## Smoke Test

From the repo root:

```bash
./bin/pip-chaser market-context collect --symbol EUR_USD --timeframe 15m --count 50
```

Expected result:

- JSON output
- `symbol` is `EUR_USD`
- `timeframe` is `15m`
- `source.name` is `oanda_candles`
- candles include `timestamp`, `open`, `high`, `low`, `close`, `volume`, and `complete`

## Safety Notes

- The adapter only fetches candles.
- It does not know account balance.
- It does not place orders.
- It does not compute entries, stops, or targets.
- Missing Moving Average, RSI, and MACD confirmation is reported as missing.
