# Pip Chaser Milestones

This file turns the PRD into a trackable build checklist.

Status key:
- `[x]` done
- `[ ]` not started
- `[-]` intentionally deferred

## Milestone 0: Project Framing
Goal: lock the architecture and avoid building the wrong thing first.

- [x] Pick OANDA as the paper-trading broker
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
- [ ] Choose the VPS provider and machine size
- [ ] Provision the Linux VPS
- [ ] Install and verify OpenClaw
- [ ] Connect Telegram to OpenClaw
- [ ] Configure the chosen LLM provider
- [ ] Set up paper-only environment variables and secret storage
- [ ] Verify the bot can receive and reply to Telegram messages
- [ ] Verify a restart does not break the basic OpenClaw + Telegram runtime

Definition of done:
- A hosted OpenClaw instance is reachable through Telegram
- The environment is paper-only and secrets are stored safely

## Milestone 2: Strategy Skill
Goal: encode the PDF trading doctrine into a reusable OpenClaw skill.

- [ ] Create the workspace skill folder
- [ ] Write `SKILL.md` for the PDF strategy
- [ ] Define what counts as a valid setup
- [ ] Define what counts as an invalid or weak setup
- [ ] Encode timeframe requirements
- [ ] Encode wick rejection logic
- [ ] Encode support/resistance logic
- [ ] Encode confirmation candle logic
- [ ] Encode stop-loss and take-profit doctrine
- [ ] Encode how the bot should explain a trade in plain English
- [ ] Test the skill on sample setups and non-setups

Definition of done:
- The skill can consistently explain why a setup passes or fails
- The strategy logic is clearly grounded in the PDF

## Milestone 3: Market Context Inputs
Goal: define and fetch the minimum data the workflows need.

- [ ] Decide the minimum symbols to support first
- [ ] Decide the minimum timeframes to support first
- [ ] Define the structured setup-validation input format
- [ ] Pull OANDA candle data for the primary timeframe
- [ ] Pull any lower-timeframe confirmation data needed
- [ ] Normalize candle data into the workflow input format
- [ ] Decide whether to include chart images in v1
- [ ] Evaluate reusable MCP/context tools for calendars or market context
- [ ] Reject tools that add noise without helping the strategy

Definition of done:
- The agent has a clean, repeatable data shape for evaluating setups
- Real OANDA paper-market data can flow into the validation process

## Milestone 4: Lobster Workflow Design
Goal: define deterministic trading workflows before allowing execution.

- [ ] Implement `market_scan`
- [ ] Implement `validate_setup`
- [ ] Implement `trade_explain`
- [ ] Implement `daily_summary`
- [ ] Define `paper_trade_execute`
- [ ] Document the input/output contract for each workflow
- [ ] Add checkpoints so no execution happens before validation and risk checks
- [ ] Add workflow-level tracing so each run is identifiable

Definition of done:
- The main workflows exist and run in the correct order
- Validation and explanation can run without broker execution

## Milestone 5: Risk and Safety Layer
Goal: prevent bad trades even in paper mode.

- [ ] Define max risk per trade
- [ ] Define max total open risk
- [ ] Define max trades per symbol
- [ ] Define max concurrent trades
- [ ] Define spread caps
- [ ] Define cooldown behavior after losses
- [ ] Define pause mode behavior
- [ ] Define duplicate-order protection rules
- [ ] Define paper/live credential separation rules
- [ ] Ensure every broker action requires a recorded reason

Definition of done:
- No workflow can reach OANDA execution without passing hard risk checks
- Paper/live separation is enforced operationally, not just by convention

## Milestone 6: OANDA Execution Boundary
Goal: create the narrow broker interface and keep it tightly scoped.

- [ ] Define the OANDA execution tool/service contract
- [ ] Implement paper-order submission
- [ ] Implement stop-loss updates
- [ ] Implement trade close actions
- [ ] Implement structured execution responses
- [ ] Implement idempotency and retry protection
- [ ] Handle OANDA API failures gracefully
- [ ] Log every execution request and result

Definition of done:
- The agent can place and manage paper trades through one narrow, auditable boundary
- Duplicate or unsafe retries are blocked

## Milestone 7: Telegram User Experience
Goal: make the bot useful and understandable from chat.

- [ ] Implement status replies
- [ ] Implement position inspection replies
- [ ] Implement trade explanation replies
- [ ] Implement pause/resume commands
- [ ] Implement scan-on-demand commands
- [ ] Make ambiguous commands safe by default
- [ ] Ensure questions are not accidentally treated as trade orders
- [ ] Send clean trade result updates back to Telegram

Definition of done:
- The user can inspect, understand, and control the paper-trading agent from Telegram

## Milestone 8: Journaling, Logs, and Review
Goal: make every decision auditable and reviewable.

- [ ] Journal every workflow run
- [ ] Journal every setup decision
- [ ] Journal every paper trade request
- [ ] Journal every OANDA result
- [ ] Add daily summaries
- [ ] Add failure summaries
- [ ] Add enough logs to reconstruct what happened after an incident

Definition of done:
- The team can review any paper trade and understand the full reasoning and execution path

## Milestone 9: Paper Trading Trial
Goal: run the full system continuously and learn from real behavior.

- [ ] Run the bot continuously on paper trading
- [ ] Review trade quality
- [ ] Review skipped setups
- [ ] Review false positives
- [ ] Review explanation quality
- [ ] Review stability under restarts or outages
- [ ] Review duplicate-command and duplicate-workflow behavior
- [ ] Tune strategy skill or workflows based on findings

Definition of done:
- The paper-trading loop behaves predictably enough to assess whether the system deserves live consideration

## Milestone 10: Live Trading Readiness Review
Goal: decide whether the project is ready to touch real money.

- [ ] Define live go/no-go criteria
- [ ] Confirm several weeks of stable paper operation
- [ ] Confirm no critical safety failures
- [ ] Confirm no duplicate live-equivalent orders
- [ ] Confirm the explanations are understandable and trustworthy
- [ ] Confirm acceptable performance over a meaningful sample
- [ ] Create separate live credentials and environment
- [ ] Create a live trading kill-switch procedure
- [ ] Define smaller initial live position sizing
- [ ] Define stricter daily loss caps for first live rollout

Definition of done:
- There is an explicit, evidence-based case for moving from paper to cash

## Current Recommended Build Order
If we start building now, the next sequence should be:

1. Milestone 2: Strategy Skill
2. Milestone 4: Lobster Workflow Design
3. Milestone 1: OpenClaw Runtime and Hosting
4. Milestone 3: Market Context Inputs
5. Milestone 5: Risk and Safety Layer
6. Milestone 6: OANDA Execution Boundary
7. Milestone 7: Telegram User Experience
8. Milestone 8: Journaling, Logs, and Review
9. Milestone 9: Paper Trading Trial
10. Milestone 10: Live Trading Readiness Review
