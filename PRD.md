# Pip Chaser PRD

## Product Summary
Pip Chaser is a Telegram-based forex agent that uses OpenClaw as its gateway, skills host, and workflow runtime.

Version 1 is `paper-trading first`, but the current strategy document only defines `Step 1: Detection`. That means the immediate product is not a full auto-trader yet. It is an explainable detection agent that:
- scans for bullish and bearish fractals
- checks context around those fractals
- explains whether a detection is strong, weak, or invalid
- alerts the user in Telegram when a valid detection appears

OANDA remains the planned paper-trading venue, but broker execution stays deferred until the strategy doctrine includes explicit entry, invalidation, and management rules.

## Goal
The goal is to build an agent that can:
- talk with the user in Telegram
- scan supported forex symbols for fractal detections from the PDF
- explain what it sees in plain English
- run deterministic OpenClaw/Lobster workflows before any later broker action
- notify the user when a valid detection appears
- keep a clean journal of what it saw and why it did or did not alert

In short:
- Telegram is the conversation and alert channel
- OpenClaw is the runtime
- Skills hold the strategy doctrine
- Lobster holds the ordered workflows
- OANDA is a later paper-execution boundary, not a Milestone 2 dependency

## Success Criteria
Version 1 is successful if it can:
- run continuously on a Linux VPS without manual babysitting
- use OpenClaw as the Telegram-facing runtime
- detect only setups that match the fractal PDF doctrine
- explain every detection in Telegram in plain English
- distinguish valid, weak, and invalid detections consistently
- keep a clear journal of what it saw and why it alerted or stayed quiet
- survive common failures without duplicated alerts or unsafe behavior

Paper trading and real-money trading should happen only after:
- the detection logic is stable
- the explanations are trustworthy
- later execution rules are defined clearly enough to automate safely

## Core Architecture
### 1) Telegram/OpenClaw Layer
Telegram is the user interface, and OpenClaw is the always-on gateway.

OpenClaw is responsible for:
- receiving Telegram messages and commands
- managing conversation context
- hosting skills and tool access
- invoking Lobster workflows
- returning explanations and alerts to the user

### 2) Strategy Skill
The current PDF should be implemented as an OpenClaw skill focused on `fractal detection`.

This skill owns:
- the fractal doctrine from the PDF
- setup interpretation rules
- explanation style
- what counts as valid, weak, or invalid detection

For this document, the skill should encode:
- the 5-candle fractal structure
- bullish fractal logic
- bearish fractal logic
- the supported timeframes: `15m`, `1h`, `4h`, `Daily`
- support/resistance interpretation
- reversal, breakout, and trend-confirmation interpretation
- indicator confirmation guidance using the visible TradingView indicators

It should not invent:
- entry prices
- stop-loss or take-profit rules
- position sizing
- autonomous broker execution logic

### 3) Lobster Workflows
Lobster is the deterministic workflow layer.

Version 1 should focus on:
- `market_scan`
- `validate_setup`
- `trade_explain`
- `daily_summary`

`paper_trade_execute` remains deferred until the execution doctrine is defined by a later strategy document.

### 4) MCP and Tool Reuse
The project should prefer existing OpenClaw-compatible tools before building custom glue.

That means:
- reuse OpenClaw Telegram support
- reuse OpenClaw skills
- reuse Lobster workflows
- reuse MCP-compatible market context tools where helpful
- keep custom code narrow and strategy-specific

### 5) OANDA Execution Boundary
OANDA remains the planned broker boundary, but it is not part of Milestone 2 delivery.

When the strategy evolves beyond detection, the OANDA boundary should own:
- order placement
- stop updates
- trade closes
- execution responses
- duplicate-order protection

Until then, OANDA should stay out of the active runtime path.

## Infrastructure
### Recommended Setup
The recommended version 1 setup is a Linux VPS that runs:
- OpenClaw
- Telegram integration
- the chosen LLM provider connection
- the fractal-detection skill
- Lobster workflows
- journaling and logs

Because OANDA is API-first, later paper execution can also stay on Linux.

### Deployment Model
The preferred model is:
- OpenClaw as the Telegram-facing gateway
- Lobster as the workflow engine
- a fractal-detection skill as the main strategy surface
- paper-only credentials in the environment

## Architecture Diagram
```text
User in Telegram
      |
      v
+-----------------------+
| Telegram + OpenClaw   |
| chat, commands, state |
+-----------------------+
      |
      v
+-----------------------+
| Lobster Workflow      |
| deterministic flow    |
+-----------------------+
      |
      +-------------------------+
      |                         |
      v                         v
+-----------------------+   +-----------------------+
| Fractal Detection     |   | Market Context Tools  |
| Skill                 |   | prices, chart context |
+-----------------------+   +-----------------------+
      |
      v
+-----------------------+
| Journal and Alerts    |
| Telegram + logs       |
+-----------------------+

Later phase only:
      |
      v
+-----------------------+
| OANDA Execution Tool  |
+-----------------------+
```

## OpenClaw-First Implementation Sequence
### Phase 1: OpenClaw Gateway and Telegram
Set up:
- OpenClaw runtime
- Telegram channel integration
- DM and group allowlists
- paper-only environment separation

### Phase 2: Fractal Detection Skill
Create the workspace skill that encodes the PDF strategy:
- fractal criteria
- weak or invalid detection rules
- timeframe rules
- explanation rules
- Telegram alert drafting

### Phase 3: Lobster Workflows
Define the detection-first workflows:
- `market_scan`
- `validate_setup`
- `trade_explain`
- `daily_summary`

Each workflow should make clear:
- what inputs it expects
- what tools it can call
- what counts as enough evidence to alert

### Phase 4: Market Context Inputs
Add:
- candle data collection
- timeframe normalization
- optional chart context
- indicator context where available

### Phase 5: Later Execution Boundary
Only after a later strategy document defines actual trade rules:
- add the narrow OANDA paper-trading boundary
- add risk gating
- add trade lifecycle workflows

## One Example Use Case
### Use Case: The bot finds a valid fractal detection and alerts the user
1. The user asks the bot to scan a symbol in Telegram, or a scheduled scan runs.
2. OpenClaw starts the `market_scan` workflow.
3. The workflow gathers candles and passes them to the fractal-detection skill.
4. The skill checks whether a bullish or bearish fractal is actually present.
5. The skill checks whether support/resistance, trend context, and indicator context strengthen or weaken the signal.
6. If the setup is valid enough, OpenClaw sends a Telegram alert that includes:
   - the symbol
   - the timeframe
   - whether the fractal is bullish or bearish
   - why the signal is valid
   - any missing or weak context the user should know
7. The result is journaled for later review.

That means the first live behavior is explainable market detection, not unbounded autonomous execution.

## Public Interfaces and Ownership
### Fractal Detection Skill
The skill owns:
- the PDF strategy doctrine
- pass/fail/weak classification
- plain-English reasoning
- Telegram notification drafting

Suggested output shape:
- `valid_detection: true|false`
- `direction: bullish|bearish|none`
- `timeframe`
- `reasoning_summary`
- `confirmation_notes`
- `telegram_notification_draft`
- `missing_information`

### Lobster Workflows
The workflows own:
- ordered execution
- input/output contracts
- scan orchestration
- alert generation order

### Telegram/OpenClaw Layer
This layer owns:
- commands
- conversation
- inspection
- delivery of alerts and summaries

### OANDA Boundary
Deferred for now.
When activated later, it will own broker actions only.

## Edge Cases to Address
### Strategy and data issues
- only 4 candles are available, so the fractal is incomplete
- 5 candles exist, but the middle candle is not the extreme
- support/resistance context is missing
- trend context conflicts with the fractal interpretation
- indicator confirmation is unavailable or contradictory
- timeframe context is incomplete or mixed

### Telegram and operator issues
- duplicate Telegram commands are sent
- group messages should not trigger the bot unless it is mentioned
- non-allowed users should not trigger owner-only behavior
- ambiguous user messages should be treated as questions, not commands

### Infrastructure issues
- VPS restart
- OpenClaw restart
- temporary Telegram outage
- stale market snapshot
- duplicate workflow invocation

## Recommendation
The cleanest next version of Pip Chaser is:
- an OpenClaw Telegram agent
- with a PDF-based fractal detection skill
- with Lobster-managed detection workflows
- with strong explanations and alerting
- and with OANDA still waiting behind a later execution phase

That keeps the product honest to the actual PDF, avoids premature broker automation, and gives us a strong detection layer we can trust before moving to paper execution.
