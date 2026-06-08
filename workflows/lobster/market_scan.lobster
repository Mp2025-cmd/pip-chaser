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
    command: "pip-chaser market-context validate-request --json"
  - id: collect_context
    command: "./bin/pip-chaser market-context collect --symbol EUR_USD --timeframe 15m --count 50"
    stdin: $validate_request.json
  - id: validate_setups
    command: "./bin/pip-chaser workflows validate-setup"
    stdin: $collect_context.json
  - id: explain_alerts
    command: "./bin/pip-chaser workflows trade-explain"
    stdin: $validate_setups.json
  - id: summarize
    command: "./bin/pip-chaser workflows summarize-scan"
    stdin: $explain_alerts.json
