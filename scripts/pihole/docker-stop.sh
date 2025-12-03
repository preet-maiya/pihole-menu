#!/bin/bash

# Gracefully ask Docker apps to quit (covers both names)
osascript <<'EOF'
ignoring application responses
  tell application "Docker Desktop" to quit
  tell application "Docker" to quit
end ignoring
EOF

# Wait for Docker engine to stop (up to ~30s)
for i in {1..30}; do
  if ! docker info >/dev/null 2>&1; then
    exit 0
  fi
  sleep 1
done

# If it's still up, force kill common Docker Desktop processes
pkill -f 'Docker Desktop.app'       >/dev/null 2>&1 || true
pkill -f 'com.docker.backend'       >/dev/null 2>&1 || true
pkill -f 'Docker Desktop'           >/dev/null 2>&1 || true
pkill -f 'Docker.app'               >/dev/null 2>&1 || true

# Final check (optional)
if ! docker info >/dev/null 2>&1; then
  exit 0
else
  exit 1
fi
