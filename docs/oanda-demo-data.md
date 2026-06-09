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

For local testing, copy `.env.example` to `.env.local` and set the demo token there.

```bash
cp .env.example .env.local
```

Then edit `.env.local`:

```bash
OANDA_PAPER_API_KEY=your-demo-token
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

Quick latest closed-candle price:

```bash
./bin/pip-chaser market-context price --symbol XAU_USD
```

OANDA read calls retry transient HTTP `429` and `5xx` failures before returning a workflow failure.

Expected result:

- JSON output
- `symbol` is `EUR_USD`
- `timeframe` is `15m`
- `source.name` is `oanda_candles`
- candles include `timestamp`, `open`, `high`, `low`, `close`, `volume`, and `complete`

## Fractal Detection Smoke Test

```bash
set -a
source .env.local
set +a

./bin/pip-chaser market-context collect --symbol EUR_USD --timeframe 15m --count 50 \
  | ./bin/pip-chaser workflows validate-setup
```

Expected result:

- JSON output
- `classification` is `valid`, `weak`, or `invalid`
- `direction` is `bullish`, `bearish`, or `none`
- weak results list missing confirmation context
- every response says detection only and does not imply a trade

## Safety Notes

- The adapter only fetches candles.
- It does not know account balance.
- It does not place orders.
- It does not compute entries, stops, or targets.
- Missing Moving Average, RSI, and MACD confirmation is reported as missing.
