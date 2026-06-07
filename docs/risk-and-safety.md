# Pip Chaser Risk and Safety Rules

This document defines the safety layer for Pip Chaser before any broker execution is allowed.

The current system is `detection only`. It can explain chart setups and send Telegram alerts, but it must not place trades until a later strategy document defines exact execution rules.

## Safety Principles

- Detection is allowed.
- Explanation is allowed.
- Telegram alerts are allowed.
- Broker execution is not allowed in the current version.
- Paper trading can only be added after explicit entry, stop, take-profit, invalidation, and trade-management rules exist.
- Live trading must stay out of scope until paper-mode behavior has been reviewed and approved.

## Execution Activation Requirements

Future broker execution can only be activated when all of these are true:

- The strategy doctrine defines exact entry conditions.
- The strategy doctrine defines stop-loss placement.
- The strategy doctrine defines take-profit or exit-management rules.
- The strategy doctrine defines invalidation rules.
- The project has a narrow OANDA paper-execution service or tool.
- The runtime can prove it is using paper credentials, not live credentials.
- Every execution request includes a recorded reason.
- Duplicate-order protection exists.
- Pause mode exists and has been tested.
- Telegram owner controls for pause/resume are working.

If any item is missing, the bot must stay in detection-only mode.

## Pause Mode

Pause mode is a global safety switch.

When paused, the agent may:
- answer questions
- explain old detections
- summarize journaled activity
- say that scanning or execution is paused

When paused, the agent must not:
- start new market scans
- send new detection alerts
- trigger any broker action
- retry failed workflow runs automatically

Pause mode should be controlled only by approved owner commands, not ordinary group messages.

Recommended commands for later Telegram UX:
- `/pause`
- `/resume`
- `/status`

## Duplicate Protection

The agent must avoid repeating the same alert or workflow accidentally.

Every workflow run should have a unique ID.

Every detection alert should be deduplicated by:
- symbol
- timeframe
- fractal direction
- center candle timestamp
- workflow name

If the same detection is seen again, the bot should update or suppress the duplicate instead of sending another alert.

Duplicate broker execution must be blocked entirely. A later OANDA tool should require an idempotency key before it accepts any order request.

## Paper and Live Separation

The project is paper-first.

Paper and live credentials must never share the same environment variable names.

Recommended environment naming:
- `OANDA_PAPER_API_KEY`
- `OANDA_PAPER_ACCOUNT_ID`
- `OANDA_PAPER_ENVIRONMENT`
- `OANDA_LIVE_API_KEY`
- `OANDA_LIVE_ACCOUNT_ID`
- `OANDA_LIVE_ENVIRONMENT`

The v1 runtime should only load paper variables.

Live variables should not be present on the VPS until the project passes a live-readiness review.

If both paper and live credentials are detected in the same runtime, the agent should refuse execution and report the configuration problem.

## Recorded Reason Requirement

Every future broker action must include a structured reason.

Minimum reason fields:
- `workflow_run_id`
- `symbol`
- `timeframe`
- `strategy_version`
- `detection_direction`
- `entry_rule_matched`
- `risk_rule_matched`
- `telegram_request_id` or `scheduled_scan_id`
- `paper_or_live`

If the agent cannot explain why an action is happening, the action must not happen.

## Safe Defaults

If the agent is unsure, it should choose the safer behavior.

Safe defaults:
- treat ambiguous Telegram messages as questions
- treat missing market data as no signal
- treat missing indicator confirmation as weak confidence
- treat missing strategy doctrine as no execution
- treat repeated commands as possible duplicates
- treat OpenClaw, Telegram, market-data, or OANDA errors as stop-and-report events

## Current Milestone 5 Decision

Milestone 5 is complete when these rules are documented and accepted as the safety baseline.

No broker code is required for this milestone.

The next implementation work should use these rules when designing:
- Lobster workflows
- Telegram commands
- journaling
- future OANDA paper execution
