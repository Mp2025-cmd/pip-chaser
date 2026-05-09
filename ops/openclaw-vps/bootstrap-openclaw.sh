#!/usr/bin/env bash
set -euo pipefail

# Milestone 1 bootstrap for a Linux VPS.
# This installs OpenClaw using the official installer, but leaves onboarding
# and secret entry to the operator so credentials do not get baked into scripts.

echo "==> Checking platform"
uname -a

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This bootstrap currently expects an apt-based Linux distribution."
  echo "Recommended target: Ubuntu 24.04 LTS."
  exit 1
fi

echo "==> Installing base packages"
sudo apt-get update
sudo apt-get install -y \
  ca-certificates \
  curl \
  git \
  jq \
  unzip

echo "==> Installing OpenClaw without onboarding"
curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard

echo "==> Verifying OpenClaw CLI"
export PATH="$(npm prefix -g)/bin:$PATH"
openclaw --version

echo "==> Running basic diagnostics"
openclaw doctor || true

cat <<'EOF'

Next manual steps:

1. Run onboarding and install the managed service:
   openclaw onboard --install-daemon

2. Verify the gateway:
   openclaw gateway status

3. Connect Telegram:
   openclaw channels add --channel telegram --token "<telegram-bot-token>"

4. Confirm health:
   openclaw doctor
   openclaw gateway status

5. Send a Telegram message to the bot and confirm it replies.

Paper-trading safety:
- do not load live OANDA credentials into this environment
- use paper-only secrets and config from day one

EOF

