name: validate_setup
args:
  market_context:
    default: null
steps:
  - id: validate_schema
    command: "./bin/pip-chaser schemas validate --schema schemas/market-context.schema.json"
  - id: classify_fractal
    command: "./bin/pip-chaser strategy classify-fractal"
    stdin: $validate_schema.json
  - id: validate_result_schema
    command: "./bin/pip-chaser schemas validate --schema schemas/detection-result.schema.json"
    stdin: $classify_fractal.json
