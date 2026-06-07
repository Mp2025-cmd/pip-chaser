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
    command: "pip-chaser market-context collect --json"
    stdin: $validate_request.json
  - id: validate_setups
    command: "pip-chaser workflows validate-setup --json"
    stdin: $collect_context.json
  - id: explain_alerts
    command: "pip-chaser workflows trade-explain --json"
    stdin: $validate_setups.json
  - id: summarize
    command: "pip-chaser workflows summarize-scan --json"
    stdin: $explain_alerts.json
