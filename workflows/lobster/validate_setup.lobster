name: validate_setup
args:
  market_context:
    default: null
steps:
  - id: validate_schema
    command: "pip-chaser schemas validate --schema schemas/market-context.schema.json --json"
  - id: classify_fractal
    command: "pip-chaser strategy classify-fractal --json"
    stdin: $validate_schema.json
  - id: apply_confirmations
    command: "pip-chaser strategy apply-confirmations --json"
    stdin: $classify_fractal.json
  - id: validate_result_schema
    command: "pip-chaser schemas validate --schema schemas/detection-result.schema.json --json"
    stdin: $apply_confirmations.json
