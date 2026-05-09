# Pip Chaser PRD

## Product Summary
Pip Chaser is a Telegram-based forex trading agent that uses OpenClaw as its gateway, skills, and orchestration host. It trades on an OANDA paper account and must stay grounded in the strategy defined by the PDF document.

This is not a free-form AI trader. The strategy doctrine comes from the PDF. The agent can explain, inspect, and manage trades in natural language, but its trade decisions must stay inside that doctrine and pass hard safety rails before any broker action is allowed.

Version 1 is paper trading only. Real-money trading comes later only if paper trading proves the system is stable, understandable, and safe.

## Goal
The goal is to build a trading agent that can:
- talk with the user in Telegram
- scan forex markets for setups that match the PDF strategy
- explain what it sees in plain English
- run deterministic workflows before any trade action
- place paper trades through OANDA only after all checks pass
- report trade decisions, risk context, and results back in Telegram

In short:
- Telegram is the conversation channel
- OpenClaw is the agent gateway and tool host
- Skills are where the PDF strategy doctrine lives
- Lobster is the workflow engine
- OANDA paper trading is the execution venue

## Success Criteria
Version 1 is successful if it can:
- run continuously on a Linux VPS without manual babysitting
- use OpenClaw as the Telegram-facing runtime
- trade only setups that match the PDF strategy doctrine
- run deterministic Lobster workflows before paper execution
- enforce hard risk rules before every broker call
- explain every trade in Telegram in plain English
- keep a clear journal of what it saw, why it acted, and what happened
- survive common failures without duplicate or dangerous orders

The live-money version should only happen after paper trading proves:
- stable uptime
- sensible behavior
- reliable safety controls
- understandable trade reasoning
- acceptable performance over a meaningful sample of trades

## Core Architecture
### 1) Telegram/OpenClaw Layer
Telegram is the user interface, and OpenClaw is the always-on gateway that lives there.

OpenClaw is responsible for:
- receiving Telegram messages and commands
- managing conversation context
- hosting skills and tool access
- invoking Lobster workflows
- returning explanations and reports back to the user

This is the main layer the user interacts with. Telegram is not just an alert feed. It is the conversation and inspection layer for the trading agent.

### 2) Strategy Skill
The PDF strategy should be implemented as an OpenClaw skill.

This skill owns:
- the strategy doctrine
- setup interpretation rules
- trade explanation style
- what counts as a valid or invalid setup

Examples of what the skill should encode:
- the correct main timeframe
- wick rejection structure
- support/resistance context
- confirmation candle behavior
- stop-loss placement rules
- take-profit structure

The point of the skill is to keep the agent anchored to the PDF instead of drifting into random discretionary behavior.

### 3) Lobster Workflows
Lobster is the deterministic workflow layer that should sequence the multi-step trading flows.

Lobster should be used for named workflows such as:
- `market_scan`
- `validate_setup`
- `paper_trade_execute`
- `trade_explain`
- `daily_summary`

Lobster owns the ordered steps and checkpoints. The LLM still reasons inside the workflow, but the workflow itself controls what happens first, what must be validated, and what can trigger execution.

### 4) MCP and Tool Reuse
The project should prefer existing OpenClaw-compatible tools before building custom integration glue.

That means:
- reuse OpenClaw Telegram support
- reuse OpenClaw skills
- reuse Lobster workflows
- reuse MCP-compatible market context or calendar tools where helpful
- build custom code only for the strategy-specific and broker-specific parts

### 5) OANDA Execution Tool/Service
OANDA should remain behind a narrow execution boundary.

This boundary owns:
- order placement
- stop updates
- trade closes
- execution responses
- idempotency and duplicate-order protection

The agent should not get broad in-process broker authority. The only broker-touching component should be this execution tool or service.

## Infrastructure
### Recommended Setup
The recommended setup for version 1 is a Linux VPS that runs:
- OpenClaw
- Telegram integration
- the chosen LLM provider connection
- the strategy skill
- Lobster workflows
- a narrow OANDA execution tool/service
- journaling and logs

This is cleaner than a desktop-terminal-based broker architecture because OANDA is API-first and does not require a desktop terminal.

### Deployment Model
The preferred model is:
- OpenClaw as the Telegram-facing gateway
- Lobster as the workflow engine
- a small OANDA execution boundary for broker actions
- paper-trading-only credentials in the environment

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
| Strategy Skill        |   | Market Context Tools  |
| PDF doctrine          |   | prices, calendars     |
+-----------------------+   +-----------------------+
      |
      v
+-----------------------+
| Risk and Safety       |
| hard approval gates   |
+-----------------------+
      |
      v
+-----------------------+
| OANDA Execution Tool  |
| narrow broker surface |
+-----------------------+
      |
      v
+-----------------------+
| OANDA Paper Account   |
+-----------------------+
      |
      v
+-----------------------+
| Journal and Reporting |
| Telegram + logs       |
+-----------------------+
```

## OpenClaw-First Implementation Sequence
### Phase 1: OpenClaw Gateway and Telegram
Set up:
- OpenClaw runtime
- Telegram channel integration
- slash-command or command-handling conventions
- paper-trading-only environment separation

### Phase 2: Strategy Skill
Create the workspace skill that encodes the PDF strategy:
- setup criteria
- invalidation logic
- explanation rules
- trading doctrine language

### Phase 3: Lobster Workflows
Define the deterministic workflows:
- `market_scan`
- `validate_setup`
- `paper_trade_execute`
- `trade_explain`
- `daily_summary`

Each workflow should make clear:
- what inputs it expects
- what tools it can call
- what must pass before execution continues

### Phase 4: OANDA Execution Boundary
Build the narrow OANDA execution tool/service:
- submit paper order
- modify stop
- close trade
- return structured execution results
- reject duplicates and unsafe retries

### Phase 5: Paper Trading Observability
Add:
- trade journaling
- Telegram status and explanation responses
- logs for every workflow run
- review loops for paper-trade quality and failure analysis

## One Example Use Case
### Use Case: The bot finds a valid setup and reports it
1. The user talks to the bot in Telegram or the scan runs on schedule.
2. OpenClaw starts the `market_scan` Lobster workflow.
3. The workflow gathers market context and passes the setup to the strategy skill.
4. The strategy skill checks whether the setup matches the PDF doctrine.
5. If it matches, the workflow runs `validate_setup` and risk checks.
6. If all gates pass, the workflow calls the narrow OANDA execution tool to place the paper trade.
7. The execution result is journaled.
8. OpenClaw sends the user a Telegram explanation that includes:
   - the pair
   - why the setup matched the strategy
   - stop-loss and take-profit context
   - whether the trade was placed or skipped
   - any risk notes worth knowing

That means the system is not just auto-trading. It is building an explainable, workflow-driven trading process that the user can inspect.

## Public Interfaces and Ownership
### Strategy Skill
Owns:
- the PDF strategy doctrine
- decision rubric
- explanation style

### Lobster Workflows
Own:
- ordered multi-step trading flows
- checkpoints between reasoning and execution
- the difference between scan, validate, execute, explain, and summarize tasks

### OANDA Execution Tool/Service
Owns:
- order placement
- stop updates
- trade closes
- structured execution responses
- duplicate-order protection

### Telegram/OpenClaw Layer
Owns:
- conversation
- commands
- inspection
- trade reporting
- daily summaries

## Edge Cases We Need To Handle
### Workflow and reasoning issues
- the skill says a setup is invalid but a user asks the agent to force a trade
- the LLM explanation sounds stronger than the actual setup quality
- a workflow is retried mid-run and risks duplicate execution
- market context tools disagree with each other

### Broker and execution issues
- OANDA API is unavailable
- price moves before the paper order is submitted
- order placement succeeds but follow-up stop logic fails
- duplicate order submission happens after a retry

### Telegram and operator issues
- duplicate Telegram commands are sent
- a user message sounds like a trade instruction but is really just a question
- the bot is paused but a scheduled scan still fires
- the user wants an explanation while the system is recovering from an outage

### Reliability issues
- VPS restarts during an active workflow
- logs or journal writes fail
- a scheduled workflow runs twice
- credentials are misconfigured for paper/live separation

## Guardrails For Paper Trading
Even in paper trading, the system should enforce:
- paper mode must be explicit in logs and Telegram
- live credentials must not be present in the paper environment
- every workflow run must be traceable
- every order must carry a request ID
- every broker action must have a recorded reason
- pause mode must stop new paper trades but still allow inspection and close flows

## Graduation Path To Real Money
The system should not move to cash just because it feels good. It should graduate only after clear evidence.

Suggested graduation gates:
- several weeks of continuous paper trading
- no critical safety failures
- no duplicate live-equivalent orders
- stable uptime
- clear and understandable trade explanations
- acceptable strategy performance over a meaningful sample
- manual review of losses, skips, and strange decisions
- separate live credentials, environment, and approval checklist

When we later move to real money, the first live version should still start small:
- lower position size
- tighter daily loss cap
- stricter trading hours
- manual monitoring during early sessions
- fast kill switch if behavior looks wrong

## Why This Design Makes Sense
- It keeps the trading strategy anchored to the PDF.
- It uses OpenClaw for what it is already good at: Telegram-native agent behavior.
- It uses Lobster to make trading flows deterministic instead of improvised.
- It prefers MCP/tool reuse before custom glue.
- It keeps OANDA in a narrow execution role.
- It separates conversation, reasoning, workflow control, and broker execution.

## What This Is Not
This is not:
- a fully unbounded AI trader
- a random chat bot with direct broker access
- a custom app-first architecture
- a live-money system

Right now it should be thought of as:
- a strategy-based OpenClaw trading agent
- with Lobster-managed workflows
- a narrow OANDA paper execution layer
- and a strong Telegram conversation surface

## The Bottom Line
The simplest way to explain this project is:

Pip Chaser is a Telegram-based forex trading agent that uses OpenClaw, a PDF-based strategy skill, Lobster workflows, and a narrow OANDA paper-trading execution tool so the bot can talk naturally, trade carefully, and stay explainable.
