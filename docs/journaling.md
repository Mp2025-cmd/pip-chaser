# Pip Chaser Journaling

Pip Chaser journals detection activity as local JSONL files.

The journal is the audit trail for Milestone 8. It records what the bot saw, how it classified the setup, and what it would have said in Telegram.

## Storage

Default journal folder:

- `journal/`

Default file format:

- `journal/YYYY-MM-DD.jsonl`

The `journal/` folder is ignored by Git because it contains runtime output.

Override location:

```bash
export PIP_CHASER_JOURNAL_DIR=/path/to/journal
```

For one-off tests, pass a file directly:

```bash
./bin/pip-chaser journal list --journal-path /tmp/pip-chaser-test.jsonl
```

## Commands

Append a setup decision:

```bash
./bin/pip-chaser workflows validate-setup --journal < market-context.json
```

This writes two audit entries:

- `workflow_run`
- `setup_decision`

Append any JSON payload manually:

```bash
./bin/pip-chaser journal append --event-type setup_decision < detection-result.json
```

Telegram delivery events are journaled automatically when signal delivery is enabled:

```bash
./bin/pip-chaser workflows market-scan --journal --send-telegram
```

Delivery event statuses:

- `sent`
- `dry_run`
- `skipped`
- `failed`

List recent entries:

```bash
./bin/pip-chaser journal list --limit 10
```

Create a daily summary:

```bash
./bin/pip-chaser journal summary
```

The alias also works:

```bash
./bin/pip-chaser journal summarize
```

## Journal Entry Shape

Each line is a JSON object with:

- `journal_entry_id`
- `recorded_at`
- `event_type`
- `status`
- `workflow_run_id`
- `symbol`
- `timeframe`
- `classification`
- `direction`
- `valid_detection`
- `payload`

## Safety Notes

- Journal entries are detection-only.
- Journal entries must not contain API keys.
- Telegram delivery journals status and message IDs, never bot tokens.
- Broker execution is still disabled.
- The journal records reasoning; it does not approve trades.
