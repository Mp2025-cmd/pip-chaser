name: trade_explain
args:
  audience:
    default: "telegram_group"
  detection_result:
    default: null
steps:
  - id: validate_detection_result
    command: "pip-chaser schemas validate --schema schemas/detection-result.schema.json --json"
  - id: draft_message
    command: "pip-chaser telegram draft-detection-alert --json"
    stdin: $validate_detection_result.json
  - id: safety_check
    command: "pip-chaser telegram safety-check-message --json"
    stdin: $draft_message.json
