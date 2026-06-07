name: daily_summary
args:
  date:
    default: "today"
steps:
  - id: load_journal
    command: "pip-chaser journal list --json"
  - id: summarize_activity
    command: "pip-chaser journal summarize-detections --json"
    stdin: $load_journal.json
  - id: draft_summary
    command: "pip-chaser telegram draft-daily-summary --json"
    stdin: $summarize_activity.json
  - id: safety_check
    command: "pip-chaser telegram safety-check-message --json"
    stdin: $draft_summary.json
