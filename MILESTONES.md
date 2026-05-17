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
- [x] Lock Telegram down to allowlisted DM + one allowlisted group
- [x] Verify OpenClaw can send Telegram messages
- [ ] Verify inbound Telegram messages produce agent replies
- [ ] Verify owner-only command restrictions
- [x] Verify a service restart does not break the basic OpenClaw gateway
- [ ] Verify a restart does not break the full OpenClaw + Telegram reply loop
- [ ] Verify a VPS reboot does not break the basic OpenClaw + Telegram runtime

Definition of done:
- A hosted OpenClaw instance is reachable through Telegram
- Telegram access is narrowed to the intended owner and group
- The environment is paper-only and secrets are stored safely

Current note:
- OpenClaw is installed on the Hetzner VPS and upgraded to `2026.5.12`
- The dedicated Telegram bot is connected as `@pip_chaser_agent_bot`
- Owner Telegram user ID and the `Pip Chasers` group chat ID have been captured and allowlisted
- OpenClaw can send outbound Telegram messages to both DM and the allowed group
- Blocker: inbound Telegram messages currently reach the bot, but the agent reply path returns `All models are temporarily rate-limited. Please try again in a few minutes.`
- Next fix: add a lighter OpenAI fallback model or change the default model so Telegram replies do not depend only on `openai/gpt-5.5`

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
- [ ] Test the skill on sample detections and non-detections

Definition of done:
- The skill can consistently explain why a fractal detection passes, fails, or is weak
- The strategy logic is clearly grounded in the PDF
- The skill does not invent broker execution logic the PDF does not define

Current note:
- The workspace skill and reference files now exist in `skills/pip-chaser-fractal-detection`
- Remaining work for Milestone 2 is scenario-based validation against sample detections and non-detections

## Milestone 3: Market Context Inputs
Goal: define and fetch the minimum data the workflows need.

- [ ] Decide the minimum symbols to support first
- [ ] Decide the minimum timeframes to support first
- [ ] Define the structured setup-validation input format
- [ ] Pull candle data for the supported timeframes
- [ ] Normalize candle data into the workflow input format
- [ ] Decide whether to include chart images in v1
- [ ] Evaluate reusable MCP/context tools for market context
- [ ] Reject tools that add noise without helping the detection logic

Definition of done:
- The agent has a clean, repeatable data shape for evaluating detections
- Real market data can flow into the validation process

## Milestone 4: Lobster Workflow Design
Goal: define deterministic detection workflows before allowing execution.

- [ ] Implement `market_scan`
- [ ] Implement `validate_setup`
- [ ] Implement `trade_explain`
- [ ] Implement `daily_summary`
- [-] Defer `paper_trade_execute` until a later execution doctrine exists
- [ ] Document the input/output contract for each workflow
- [ ] Add checkpoints so no future execution happens before validation
- [ ] Add workflow-level tracing so each run is identifiable

Definition of done:
- The main detection workflows exist and run in the correct order
- Validation and explanation can run without any broker execution

## Milestone 5: Risk and Safety Layer
Goal: prepare safety rules before broker execution exists.

- [ ] Define what later broker execution will require before activation
- [ ] Define pause mode behavior
- [ ] Define duplicate-alert and duplicate-workflow protection rules
- [ ] Define paper/live credential separation rules
- [ ] Ensure every future broker action will require a recorded reason

Definition of done:
- Paper/live separation is enforced operationally, not just by convention
- The project is ready to add execution only after strategy doctrine expands

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

- [ ] Implement status replies
- [ ] Implement detection inspection replies
- [ ] Implement explanation replies
- [ ] Implement pause/resume commands
- [ ] Implement scan-on-demand commands
- [ ] Make ambiguous commands safe by default
- [ ] Ensure questions are not accidentally treated as trade orders
- [ ] Send clean detection alerts back to Telegram

Definition of done:
- The user can inspect, understand, and control the detection agent from Telegram

## Milestone 8: Journaling, Logs, and Review
Goal: make every decision auditable and reviewable.

- [ ] Journal every workflow run
- [ ] Journal every setup decision
- [ ] Add daily summaries
- [ ] Add failure summaries
- [ ] Add enough logs to reconstruct what happened after an incident

Definition of done:
- The team can review any alert and understand the full reasoning path

## Milestone 9: Detection Trial
Goal: run the full system continuously and learn from real behavior.

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
