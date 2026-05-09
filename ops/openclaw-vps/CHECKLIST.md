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

- [ ] Create a Telegram bot token with BotFather
- [x] Choose the LLM provider for the first hosted environment
- [x] Gather the LLM API key
- [ ] Keep OANDA live credentials out of this environment
- [x] If OANDA paper credentials already exist, store them separately and do not wire them yet

## 3. Install OpenClaw

- [x] SSH into the VPS
- [ ] Run `bootstrap-openclaw.sh`
- [x] Run `openclaw onboard --install-daemon`
- [x] Run `openclaw --version`
- [x] Run `openclaw doctor`
- [x] Run `openclaw gateway status`

Current OpenClaw status:
- Installed version: `2026.5.7`
- Gateway mode: `local`
- Gateway auth: `token`
- Gateway bind: `127.0.0.1:18789`
- Model provider: `OpenAI`

## 4. Connect Telegram

- [ ] Add Telegram to OpenClaw:
  - `openclaw channels add --channel telegram --token "<telegram-bot-token>"`
- [ ] Send a message to the bot from Telegram
- [ ] Confirm OpenClaw receives it
- [ ] Confirm OpenClaw can reply

## 5. Lock down Telegram access

- [ ] Set Telegram DM policy to allow only approved users
- [ ] Prefer explicit allowlists over open access
- [ ] If using a group, explicitly allow the group and allowed senders
- [ ] Keep execution permissions narrow from the start

OpenClaw Telegram docs currently recommend:
- `channels.telegram.dmPolicy: "allowlist"` for one-owner bots
- `channels.telegram.allowFrom` with numeric Telegram user IDs
- `channels.telegram.groups` for allowed group chats

## 6. Verify hosted runtime health

- [ ] Confirm OpenClaw survives a service restart
- [ ] Confirm Telegram still works after restart
- [x] Confirm OpenClaw still sees the selected LLM provider
- [x] Confirm no paper/live credential mix-up exists
- [x] Record the final VPS hostname/IP and access method

Access method:
- SSH tunnel: `ssh -N -L 18789:127.0.0.1:18789 root@91.99.75.11`
- Dashboard: `http://127.0.0.1:18789/`

## 7. Exit criteria for Milestone 1

Milestone 1 is done when:
- [x] OpenClaw runs on a Linux VPS
- [ ] Telegram is connected and working
- [ ] The hosted runtime restarts cleanly
- [x] The environment is paper-only
- [ ] The project is ready for Milestone 2: Strategy Skill

## Notes for the next milestone

The strategy PDF currently implies these later Milestone 2 requirements:
- primary timeframe: 4H
- optional confirmation timeframes: 1H, 30M, 15M
- wick rejection at support/resistance
- confirmation candle must not exceed the threshold beyond the prior candle
- fixed stop-loss and take-profit doctrine
- drawdown alerts at 20%, 40%, and 60% of stop distance

Those belong in the strategy skill, not in the VPS setup.
