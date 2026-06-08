name: trade_explain
args:
  audience:
    default: "telegram_group"
  detection_result:
    default: null
steps:
  - id: validate_detection_result
    command: "./bin/pip-chaser schemas validate --schema schemas/detection-result.schema.json"
  - id: draft_message
    command: "./bin/pip-chaser workflows trade-explain"
    stdin: $validate_detection_result.json
