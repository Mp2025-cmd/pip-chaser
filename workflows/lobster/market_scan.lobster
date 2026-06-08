name: market_scan
args:
  symbols:
    default: ["EUR_USD", "GBP_USD", "USD_JPY"]
  timeframes:
    default: ["15m", "1h", "4h", "Daily"]
  requested_by:
    default:
      channel: "manual_test"
      user_id: "unknown"
steps:
  - id: validate_request
    command: "./bin/pip-chaser workflows market-scan --journal"
  - id: review_summary
    command: "./bin/pip-chaser workflows daily-summary"
    stdin: $validate_request.json
