name: daily_summary
args:
  date:
    default: "today"
steps:
  - id: load_journal
    command: "./bin/pip-chaser journal list"
  - id: summarize_activity
    command: "./bin/pip-chaser workflows daily-summary"
    stdin: $load_journal.json
