# Pip Chaser PRD

## Product Summary
This project is an AI trading agent for forex that talks to the user through Telegram and places paper trades through OANDA.

The important part is that it is not a random free-form AI trader. It must trade using the strategy from the PDF document we discussed. The AI helps with judgment, communication, and trade management, but the overall trading style is grounded in that strategy.

Version 1 is paper trading only. If it behaves well in simulation and paper trading, the system can later graduate to real-money trading with cash.

## Goal
The goal is to build a trading agent that can:
- watch the market
- look for setups that match the PDF strategy
- explain what it sees in plain English
- place paper trades automatically
- manage those trades
- report everything back in Telegram so the user can inspect it

In short:
- Telegram is the conversation layer
- OpenClaw is the agent layer
- OANDA paper trading is the execution layer
- the PDF strategy is the rulebook

## Success Criteria
Version 1 is successful if it can:
- run continuously on a VPS without manual babysitting
- detect and trade only setups that match the PDF strategy
- explain every trade in Telegram in plain English
- enforce hard risk rules before every order
- keep a clear journal of what it saw, why it acted, and what happened
- survive common failures without sending duplicate or dangerous orders

The live-money version should only happen after paper trading proves:
- stable uptime
- sensible behavior
- reliable safety controls
- understandable trade reasoning
- acceptable performance over a meaningful sample of trades

## The Main Idea
Think of this as a small team made of software parts:

- Telegram is where the user talks to the trading agent
- OpenClaw is the always-on AI assistant running on a VPS
- The LLM is the reasoning engine behind OpenClaw
- The strategy validator checks whether a market setup matches the PDF strategy
- The risk layer makes sure the bot stays inside safe boundaries
- OANDA is where the paper trades actually get placed

The big design choice is this:

The AI does not get unlimited freedom to trade anything it wants. It can only trade inside the strategy framework from the PDF.

## Architecture
### 1) Telegram
Telegram is the user interface.

This is where the user can:
- ask the bot what it is doing
- ask why it took a trade
- ask for open positions
- inspect trade ideas
- pause or resume trading
- give the bot instructions

Telegram is not just for alerts. It is the main communication channel between the user and the trading agent.

### 2) OpenClaw on a VPS
OpenClaw is the agent runtime that stays online 24/7 on a VPS.

Its job is to:
- receive messages from Telegram
- talk to the LLM
- call the trading tools
- keep context across conversations
- act like the front desk and brain of the system

This makes it a good fit because the whole point of OpenClaw is to let an AI live inside messaging apps like Telegram.

### 3) LLM of Our Choice
OpenClaw can sit on top of different model providers, so the system is not locked into one model.

That means we can choose whichever LLM we trust most for:
- reasoning
- explaining setups
- discussing trades
- managing open positions

The LLM is the decision-making layer, but it still has to stay inside the strategy and safety boundaries we define.

### 4) Strategy Validator
This is one of the most important parts of the system.

The bot must be based on the trading strategy from the PDF. So before a trade is allowed, the system should check whether the setup actually matches the strategy.

Examples of what this validator may look for:
- the correct main timeframe
- the wick rejection structure
- support or resistance context
- confirmation candle behavior
- valid stop-loss placement
- valid take-profit structure

This keeps the bot strategy-focused instead of turning into a random AI gambler.

### 5) Risk and Safety Layer
Even on paper trading, this layer matters.

Its job is to stop bad behavior such as:
- trading the wrong symbol
- opening too many positions
- using too much size
- ignoring spread or cost limits
- continuing to trade after a kill switch should trigger

This is the hard boundary layer. The AI can think creatively, but it cannot cross these safety rules.

### 6) Execution Service
This is the part that translates approved trade actions into OANDA paper orders.

It should:
- place paper trades
- modify stops
- close positions
- report broker responses
- log what happened

This layer should be separate from the chat layer. That way, not every Telegram message has direct power over the broker.

### 7) OANDA Paper Account
This is the broker-side execution environment.

For now, OANDA is only used for paper trading so we can test:
- whether the strategy logic works
- whether the agent behaves sensibly
- whether the conversation flow is useful
- whether the whole system is stable

No real-money trading should happen until the paper workflow proves itself.

## Infrastructure
### Recommended Setup
The recommended setup for the OANDA version is a Linux VPS.

The Linux VPS should run:
- OpenClaw
- Telegram integration
- LLM orchestration
- strategy validator
- risk and safety layer
- execution service
- database and logs

This is cleaner than the MT5 version because OANDA is API-first and does not require a desktop trading terminal.

### Fast MVP Setup
If we want the quickest version, we can run everything on one Linux VPS:
- OpenClaw
- Telegram integration
- execution service
- OANDA paper trading integration
- local database

That is probably the right starting point for the prototype.

## Architecture Diagram
```text
User in Telegram
      |
      v
+------------------+
| Telegram Chat    |
| commands + review|
+------------------+
      |
      v
+------------------+
| OpenClaw on VPS  |
| agent runtime    |
+------------------+
      |
      v
+------------------+        +------------------+
| LLM Provider     |<------>| market context   |
| reasoning brain  |        | prices + charts  |
+------------------+        +------------------+
      |
      v
+------------------+
| Strategy         |
| Validator        |
| based on PDF     |
+------------------+
      |
      v
+------------------+
| Risk / Safety    |
| Layer            |
+------------------+
      |
      v
+------------------+
| Execution        |
| Service          |
+------------------+
      |
      v
+------------------+
| OANDA Paper      |
| Trading Account  |
+------------------+
      |
      v
+------------------+
| Journal / Logs   |
| and Metrics      |
+------------------+
```

## What We Can Start Building Now
### Phase 1: Skeleton
Build the basic service skeleton:
- Telegram bot connection
- OpenClaw runtime
- OANDA paper account connection
- database for trades and logs
- basic health check endpoint

### Phase 2: Strategy Logic
Build the strategy validator from the PDF:
- timeframe handling
- wick rejection detection
- support and resistance checks
- confirmation logic
- stop-loss and take-profit structure

### Phase 3: Safety Controls
Build the safety rails:
- max risk per trade
- max total open risk
- daily loss cap
- symbol allowlist
- spread cap
- cooldown after losses
- manual pause switch
- paper/live mode guard

### Phase 4: Trade Execution
Build the execution service:
- submit order
- update stop
- close trade
- record execution response
- reject duplicates

### Phase 5: Telegram Experience
Build the user-facing flow:
- status command
- positions command
- explain-this-trade command
- pause and resume commands
- automatic trade updates
- daily summary

### Phase 6: Paper Trial
Run the system continuously on paper trading and review:
- trade quality
- system stability
- safety behavior
- clarity of explanations
- edge-case handling

## One Example Use Case
### Use Case: The bot finds a valid setup and tells the user about it
1. The system watches a forex pair.
2. It sees price action that may match the PDF strategy.
3. The strategy validator checks whether the setup is actually valid.
4. If it passes, the LLM reviews the market context and decides whether the setup is worth taking.
5. The risk layer checks size, exposure, and safety limits.
6. The execution service places the paper trade in OANDA.
7. The bot sends a Telegram message that explains:
   - what pair it traded
   - why it took the trade
   - where the stop-loss is
   - where take-profit targets are
   - what the trade thesis is
8. If the user asks follow-up questions in Telegram, the bot should be able to explain the trade in normal language.

That means the system is not just auto-trading. It is also building an explainable trading workflow that the user can inspect.

## Edge Cases We Need To Handle
### Market and data issues
- price feed is delayed or stale
- market is closed but the bot tries to trade
- spread is too wide during rollover or volatility spikes
- candle data is incomplete or arrives late
- chart snapshot and structured data disagree

### Broker and execution issues
- OANDA API is unavailable
- order is rejected because price moved
- order is partially filled or filled at a worse price
- trade opens but stop-loss or take-profit update fails
- duplicate order submission happens after a retry

### Agent and prompt issues
- the LLM gives an invalid order shape
- the LLM hallucinates a symbol or wrong trade size
- the LLM tries to act outside the PDF strategy
- the LLM explanation sounds confident even when the setup is weak
- the LLM sees conflicting context between timeframes

### Telegram and operator issues
- duplicate Telegram commands are sent
- a command is ambiguous
- a user asks a question that sounds like a trade instruction
- the bot is paused but still receives market signals
- the user wants to inspect a trade while the system is recovering from an outage

### Reliability issues
- VPS restarts mid-trade
- network drops during order placement
- the database is temporarily unavailable
- the scheduler runs twice and triggers the same setup twice
- clocks drift and time-based logic becomes unreliable

## Guardrails For Paper Trading
Even in paper trading, the system should enforce:
- paper mode must be explicit and visible in logs and Telegram
- live credentials must not be present in the paper environment
- every order must carry a traceable request ID
- every trade must have a recorded reason
- every order path must be idempotent so retries do not create duplicates
- pause mode must stop new trades but still allow inspection and closing logic

## Graduation Path To Real Money
The system should not move to cash just because it feels good. It should graduate only after clear evidence.

Suggested graduation gates:
- at least several weeks of continuous paper trading
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
- It lets Telegram become a real conversation layer, not just an alert feed.
- It uses OpenClaw for what it is good at: always-on messaging-based agent behavior.
- It keeps OANDA in its proper role: execution.
- It separates reasoning from execution, which makes the system easier to understand and safer to test.

## What This Is Not
This is not:
- a fully unbounded AI trader
- a random chat bot with broker access
- a live-money system

Right now it should be thought of as:
- a strategy-based AI trading assistant
- with autonomous paper execution
- and a strong conversation layer through Telegram

## The Bottom Line
The simplest way to explain this project is:

It is a Telegram-based forex trading agent that uses OpenClaw and an LLM to monitor markets, explain ideas, and place paper trades in OANDA, but only when those trades match the strategy defined in the PDF.
