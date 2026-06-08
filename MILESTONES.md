# Pip Chaser Milestones

This file turns the PRD into a trackable build checklist.

Status key:
- `[x]` done
- `[ ]` not started
- `[-]` intentionally deferred

## Milestone 0: Project Framing
Goal: lock the architecture and avoid building the wrong thing first.

- [x] Pick OANDA as the planned paper-trading broker
- [x] Decide that Telegram is the main user conversation channel
- [x] Decide that OpenClaw is the main agent gateway
- [x] Decide that the PDF strategy is the source of truth
- [x] Decide that paper trading comes before live cash trading
- [x] Refocus the PRD around OpenClaw, Lobster, skills, and a narrow OANDA execution boundary
- [x] Remove the unused custom-app-first scaffold from the repo
- [x] Push the updated PRD to GitHub

Definition of done:
- The repo documents clearly describe the OpenClaw-first architecture
- There is no leftover confusion about MT5, Windows VPS, or app-first scaffolding

## Milestone 1: OpenClaw Runtime and Hosting
Goal: get the always-on runtime in place on a Linux VPS.

- [x] Create the VPS deployment runbook and bootstrap artifacts
- [x] Choose the VPS provider and machine size
- [x] Provision the Linux VPS
- [x] Install and verify OpenClaw
- [x] Configure the chosen LLM provider
- [x] Set up paper-only environment variables and secret storage
- [x] Create a dedicated Telegram bot token for Pip Chaser
- [x] Connect Telegram to OpenClaw
- [x] Capture the numeric Telegram user ID for allowlisting
- [x] Capture the allowed group chat ID for allowlisting
- [x] Lock Telegram down to allowlisted DMs + one allowlisted group
- [x] Verify OpenClaw can send Telegram messages
- [x] Verify inbound Telegram DMs produce agent replies
- [x] Verify inbound allowed-group mentions produce agent replies
- [ ] Verify owner-only command restrictions
- [x] Verify a service restart does not break the basic OpenClaw gateway
- [x] Verify a restart does not break the full OpenClaw + Telegram reply loop
- [ ] Verify a VPS reboot does not break the basic OpenClaw + Telegram runtime

Definition of done:
- A hosted OpenClaw instance is reachable through Telegram
- Telegram access is narrowed to approved DM users and the intended group
- The environment is paper-only and secrets are stored safely

Current note:
- OpenClaw is installed on the Hetzner VPS and upgraded to `2026.5.12`
- The dedicated Telegram bot is connected as `@pip_chaser_agent_bot`
- Owner Telegram user ID, Derek Ngwu's Telegram user ID, and the `Pip Chasers` group chat ID have been captured for allowlisting
- DMs are allowlisted for the owner and Derek Ngwu; group members can interact by mentioning the bot inside the approved group
- OpenClaw can send outbound Telegram messages to both DM and the allowed group
- Resolved blocker: the old API key/model path hit a Codex/OpenAI quota limit, so the OpenAI API key was replaced and the provider cooldown state was cleared
- Current model path: `openai/gpt-5-mini` with `openai/gpt-5-nano` and `openai/gpt-5.4-mini` as fallbacks
- Verification: OpenClaw model smoke test returned `api ok`, Telegram outbound works, and a fresh DM session replied successfully after `/new`
- Group mention verification is now working in the `Pip Chaser` group with Derek Ngwu
- Derek Ngwu's Telegram user ID is captured and applied for DM allowlisting: `944738582`
- Service restart plus Telegram reply loop is verified after the allowlist update
- Remaining Milestone 1 work: verify owner-only command restrictions and full reboot recovery

## Milestone 2: Fractal Detection Skill
Goal: encode the current PDF into a reusable OpenClaw skill focused on detection.

- [x] Create the workspace skill folder
- [x] Write `SKILL.md` for the fractal detection doctrine
- [x] Add a human-readable strategy reference distilled from the PDF
- [x] Define what counts as a valid bullish fractal
- [x] Define what counts as a valid bearish fractal
- [x] Define what counts as an invalid or weak detection
- [x] Encode timeframe requirements: `15m`, `1h`, `4h`, `Daily`
- [x] Encode support/resistance interpretation
- [x] Encode trend-confirmation guidance
- [x] Encode breakout interpretation guidance
- [x] Encode indicator confirmation guidance
- [x] Encode how the bot should explain a detection in plain English
- [x] Encode a Telegram notification draft format
- [x] Test the skill on sample detections and non-detections

Definition of done:
- The skill can consistently explain why a fractal detection passes, fails, or is weak
- The strategy logic is clearly grounded in the PDF
- The skill does not invent broker execution logic the PDF does not define

Current note:
- The workspace skill and reference files now exist in `skills/pip-chaser-fractal-detection`
- Scenario fixtures now cover bullish valid, bearish valid, invalid 4-candle, invalid non-extreme, and weak missing-confirmation cases
- Live OANDA demo candles can be piped into `./bin/pip-chaser workflows validate-setup`

## Milestone 3: Market Context Inputs
Goal: define and fetch the minimum data the workflows need.

- [x] Decide the minimum symbols to support first
- [x] Decide the minimum timeframes to support first
- [x] Define the structured setup-validation input format
- [x] Add OANDA practice candle-data adapter
- [x] Smoke test OANDA candle pulling with demo credentials
- [x] Normalize candle data into the workflow input format
- [x] Decide whether to include chart images in v1
- [x] Evaluate reusable MCP/context tools for market context
- [x] Reject tools that add noise without helping the detection logic

Definition of done:
- The agent has a clean, repeatable data shape for evaluating detections
- Real market data can flow into the validation process

Current note:
- Market context is documented in `docs/market-context-inputs.md`
- JSON schemas live in `schemas/market-context.schema.json` and `schemas/detection-result.schema.json`
- V1 symbols are `EUR_USD`, `GBP_USD`, and `USD_JPY`
- Read-only OANDA practice candle collection exists in `bin/pip-chaser market-context collect`
- OANDA practice candle smoke testing is verified for `USD_JPY` 15m and `EUR_USD` 1h
- The demo token was used only as a temporary environment variable and was not committed

## Milestone 4: Lobster Workflow Design
Goal: define deterministic detection workflows before allowing execution.

- [x] Scaffold `market_scan`
- [x] Implement runnable `validate_setup`
- [x] Scaffold `trade_explain`
- [x] Scaffold `daily_summary`
- [-] Defer `paper_trade_execute` until a later execution doctrine exists
- [x] Document the input/output contract for each workflow
- [x] Add checkpoints so no future execution happens before validation
- [x] Add workflow-level tracing so each run is identifiable

Definition of done:
- The main detection workflows exist and run in the correct order
- Validation and explanation can run without any broker execution

Current note:
- Workflow contracts are documented in `docs/lobster-workflows.md`
- Lobster scaffolds live in `workflows/lobster`
- `market_scan` now points at the local `bin/pip-chaser` OANDA candle adapter
- `validate_setup` now runs real fractal classification from market-context JSON
- Runtime execution now exists for market scanning, setup validation, trade explanation drafts, daily summaries, and journal commands
- Telegram delivery commands are still pending

## Milestone 5: Risk and Safety Layer
Goal: prepare safety rules before broker execution exists.

- [x] Define what later broker execution will require before activation
- [x] Define pause mode behavior
- [x] Define duplicate-alert and duplicate-workflow protection rules
- [x] Define paper/live credential separation rules
- [x] Ensure every future broker action will require a recorded reason

Definition of done:
- Paper/live separation is enforced operationally, not just by convention
- The project is ready to add execution only after strategy doctrine expands

Current note:
- Milestone 5 is documented in `docs/risk-and-safety.md`
- The current product remains detection-only
- Future OANDA execution must stay blocked until strategy doctrine defines entry, stop, target, invalidation, and management rules

## Milestone 6: OANDA Execution Boundary
Goal: create the narrow broker interface once the strategy supports execution.

- [-] Define the OANDA execution tool/service contract after the later strategy doctrine exists
- [-] Implement paper-order submission
- [-] Implement stop-loss updates
- [-] Implement trade close actions
- [-] Implement structured execution responses
- [-] Implement idempotency and retry protection
- [-] Handle OANDA API failures gracefully
- [-] Log every execution request and result

Definition of done:
- The agent can place and manage paper trades through one narrow, auditable boundary
- Duplicate or unsafe retries are blocked

## Milestone 7: Telegram User Experience
Goal: make the bot useful and understandable from chat.

- [x] Define status replies
- [x] Define detection inspection replies
- [x] Define explanation replies
- [x] Define pause/resume commands
- [x] Define scan-on-demand commands
- [x] Make ambiguous commands safe by default
- [x] Ensure questions are not accidentally treated as trade orders
- [x] Define clean detection alerts back to Telegram

Definition of done:
- The user can inspect, understand, and control the detection agent from Telegram

Current note:
- Milestone 7 is documented in `docs/telegram-ux.md`
- The current runtime can already respond in Telegram
- Runtime wiring for `/scan`, `/status`, `/pause`, and `/resume` should happen after Lobster workflows and market context inputs exist

## Milestone 8: Journaling, Logs, and Review
Goal: make every decision auditable and reviewable.

- [x] Journal every workflow run
- [x] Journal every setup decision
- [x] Add daily summaries
- [x] Add failure summaries
- [x] Add enough logs to reconstruct what happened after an incident

Definition of done:
- The team can review any alert and understand the full reasoning path

Current note:
- Journaling is documented in `docs/journaling.md`
- Runtime journal files are written to ignored local `journal/YYYY-MM-DD.jsonl` files
- `./bin/pip-chaser workflows validate-setup --journal` records setup decisions
- `./bin/pip-chaser journal list` and `./bin/pip-chaser journal summary` support review

## Milestone 9: Detection Trial
Goal: run the full system continuously and learn from real behavior.

- [x] Add a repeatable detection-trial scan command
- [x] Journal each trial scan result
- [x] Add duplicate-alert detection for repeated fractal candidates
- [x] Add daily trial summaries
- [x] Document the detection-trial review process
- [x] Add manual Telegram delivery for valid non-duplicate signals
- [x] Add Telegram delivery dry-run mode
- [ ] Run the bot continuously in detection mode
- [ ] Review alert quality
- [ ] Review missed detections
- [ ] Review false positives
- [ ] Review explanation quality
- [ ] Review stability under restarts or outages
- [ ] Review duplicate-command and duplicate-workflow behavior
- [ ] Tune the skill or workflows based on findings

Definition of done:
- The detection loop behaves predictably enough to justify adding execution logic later

Current note:
- The trial workflow is documented in `docs/detection-trial.md`
- `./bin/pip-chaser workflows market-scan --journal` can scan live OANDA demo candles and journal the results
- `./bin/pip-chaser workflows market-scan --journal --send-telegram` can send valid non-duplicate signals to Telegram
- `./bin/pip-chaser workflows market-scan --journal --send-telegram --dry-run` previews delivery without posting
- `./bin/pip-chaser workflows daily-summary` creates a review summary from the journal
- Milestone 9 is now ready for live observation, but it is not complete until the team reviews real scan history

## Milestone 10: Live Trading Readiness Review
Goal: decide whether the project is ready to touch real money in later phases.

- [ ] Define what additional strategy doctrine is still needed before execution
- [ ] Confirm the later execution rules are explicit enough to automate safely
- [ ] Confirm stable detection-mode operation first
- [ ] Confirm no critical safety failures
- [ ] Confirm the explanations are understandable and trustworthy
- [ ] Confirm there is an evidence-based case for progressing toward paper execution

Definition of done:
- There is an explicit, evidence-based case for moving beyond detection mode

## Current Recommended Build Order
If we keep building now, the next sequence should be:

1. Finish Milestone 1: OpenClaw Runtime and Hosting
2. Milestone 2: Fractal Detection Skill
3. Milestone 4: Lobster Workflow Design
4. Milestone 3: Market Context Inputs
5. Milestone 7: Telegram User Experience
6. Milestone 8: Journaling, Logs, and Review
7. Milestone 9: Detection Trial
8. Milestone 5: Risk and Safety Layer
9. Milestone 6: OANDA Execution Boundary
10. Milestone 10: Live Trading Readiness Review
