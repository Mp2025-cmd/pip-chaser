# Milestone 1 Checklist: OpenClaw VPS + Telegram

This is the operational checklist for getting Pip Chaser's hosted runtime online.

## 1. Provision the VPS

- [x] Choose a Linux VPS provider
- [x] Use a recent Ubuntu LTS image
- [x] Allocate enough resources for OpenClaw and later workflows
  - recommended starting point: 2 vCPU, 4 GB RAM
- [ ] Create a non-root sudo user
- [ ] Enable SSH key access
- [ ] Disable password login if possible
- [ ] Enable the firewall

Current host:
- Hetzner `CPX22`
- Ubuntu `24.04`
- IP `91.99.75.11`

## 2. Prepare secrets

- [x] Create a Telegram bot token with BotFather
- [x] Choose the LLM provider for the first hosted environment
- [x] Gather the LLM API key
- [ ] Keep OANDA live credentials out of this environment
- [x] If OANDA paper credentials already exist, store them separately and do not wire them yet

Current bot:
- Telegram bot name: `Pip Chaser`
- Telegram bot username: `@pip_chaser_agent_bot`

## 3. Install OpenClaw

- [x] SSH into the VPS
- [ ] Run `bootstrap-openclaw.sh`
- [x] Run `openclaw onboard --install-daemon`
- [x] Run `openclaw --version`
- [x] Run `openclaw doctor`
- [x] Run `openclaw gateway status`

Current OpenClaw status:
- Installed version: `2026.5.12`
- Gateway mode: `local`
- Gateway auth: `token`
- Gateway bind: `127.0.0.1:18789`
- Model provider: `OpenAI`

## 4. Connect Telegram

- [x] Power the VPS back on
- [x] Confirm SSH works again
- [x] Add Telegram to OpenClaw:
  - `openclaw channels add --channel telegram --token "<telegram-bot-token>"`
- [x] DM the bot from the owner account
- [x] Capture the numeric Telegram user ID
- [x] Add the bot to the intended group
- [x] Capture the numeric group chat ID
- [x] Confirm OpenClaw can send a DM
- [x] Confirm OpenClaw can send to the allowed group
- [x] Confirm inbound DM produces an agent reply
- [x] Confirm inbound allowed-group mention produces an agent reply

Current Telegram status:
- Bot username: `@pip_chaser_agent_bot`
- Owner user ID: captured and allowlisted in the VPS config
- Group chat ID: captured and allowlisted in the VPS config
- Group mode: mention-required, available to members of the approved group
- Resolved blocker: inbound messages previously failed because the old model/auth path hit a Codex/OpenAI quota limit
- Current model config: `openai/gpt-5-mini` with `openai/gpt-5-nano` and `openai/gpt-5.4-mini` fallbacks
- Current verification: model smoke test returned `api ok`, outbound Telegram works, `/new` starts a fresh DM session, and a short DM receives an agent reply

## 5. Lock down Telegram access

- [x] Set `channels.telegram.dmPolicy` to `allowlist`
- [x] Set `channels.telegram.allowFrom` to approved numeric Telegram user IDs
- [x] Set `channels.telegram.groupPolicy` to `allowlist`
- [x] Leave `channels.telegram.groupAllowFrom` unset so any member of the approved group can mention the bot
- [x] Add the allowed group to `channels.telegram.groups`
- [x] Set the allowed group to `requireMention: true`
- [x] Set `commands.ownerAllowFrom` to `telegram:<owner-id>`
- [x] Prefer explicit allowlists over open access
- [x] Keep execution permissions narrow from the start

OpenClaw Telegram docs currently recommend:
- `channels.telegram.dmPolicy: "allowlist"` for approved DM users
- `channels.telegram.allowFrom` with numeric Telegram user IDs
- `channels.telegram.groups` for allowed group chats

Current access model:
- DMs are allowlisted for the owner and Derek Ngwu.
- The approved group is group-chat-ID allowlisted.
- Any member in the approved group can talk to the bot by mentioning it.
- Owner-only commands remain restricted to the owner Telegram user ID.

## 6. Verify hosted runtime health

- [x] Confirm OpenClaw survives a service restart
- [x] Confirm outbound Telegram still works after service restart
- [x] Confirm inbound Telegram DMs still work after service restart
- [x] Confirm inbound allowed-group mentions still work after service restart
- [x] Confirm Derek Ngwu can DM the bot after allowlist update
- [ ] Confirm a non-allowed sender does not trigger owner-only behavior
- [ ] Confirm a non-allowed group does not trigger the bot
- [x] Confirm OpenClaw still sees the selected LLM provider
- [x] Confirm no paper/live credential mix-up exists
- [x] Record the final VPS hostname/IP and access method
- [ ] Reboot the VPS
- [ ] Confirm OpenClaw and Telegram recover after full reboot

Access method:
- SSH tunnel: `ssh -N -L 18789:127.0.0.1:18789 root@91.99.75.11`
- Dashboard: `http://127.0.0.1:18789/`

## 7. Exit criteria for Milestone 1

Milestone 1 is done when:
- [x] OpenClaw runs on a Linux VPS
- [x] Telegram is connected and working end-to-end for both DM and allowed group
- [x] The hosted runtime restarts cleanly
- [x] The environment is paper-only
- [x] Telegram access is explicitly allowlisted
- [ ] The project is ready for Milestone 2 detection workflows

Current blocker:
- The earlier model quota blocker is resolved with the new OpenAI API key.
- Group mention behavior is now verified in the `Pip Chaser` group with Derek Ngwu.
- Derek Ngwu's Telegram user ID is captured and applied for DM allowlisting: `944738582`.
- Service restart plus Telegram reply loop is verified after the allowlist update.
- Reboot the VPS once and confirm OpenClaw, Telegram, and the model path recover cleanly.

## Notes for the next milestone

The current strategy PDF defines `Step 1: Detection`, not a full trading doctrine.

Milestone 2 should therefore encode:
- 5-candle bullish and bearish fractal structure
- supported timeframes: `15m`, `1h`, `4h`, `Daily`
- support/resistance interpretation
- reversal, breakout, and trend-confirmation interpretation
- indicator confirmation using `Moving Averages`, `RSI`, and `MACD`
- plain-English Telegram alert drafting

Milestone 2 should not invent:
- entry rules
- stop-loss rules
- take-profit rules
- broker execution rules
