#!/usr/bin/env bash
# Sends every case in tests/cases to a model with lyra.md as the system prompt
# and checks that the reply has the shape lyra.md specifies.
#
# Usage:
#   tests/run.sh                                  # claude CLI, model alias "sonnet"
#   tests/run.sh --runner claude --model opus
#   tests/run.sh --runner ollama --model qwen3:8b # a local model through Ollama
#   tests/run.sh --only canary                    # cases whose name contains "canary"
#
# Runners:
#   claude  needs the claude CLI and a login
#   ollama  needs an Ollama daemon on localhost:11434 with the model pulled
#
# Case files: tests/cases/<name>.txt. The first line is "expect: optimized",
# "expect: detail" or "expect: greeting"; the rest is the message sent to Lyra.
# Replies are written to tests/out/<runner>-<model>/<name>.txt for reading.
set -u
cd "$(dirname "$0")/.."

RUNNER=claude; MODEL=; ONLY=
while [ $# -gt 0 ]; do
  case "$1" in
    --runner) RUNNER=$2; shift 2 ;;
    --model)  MODEL=$2;  shift 2 ;;
    --only)   ONLY=$2;   shift 2 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done
if [ -z "$MODEL" ]; then
  case "$RUNNER" in claude) MODEL=sonnet ;; ollama) MODEL=qwen3:8b ;; esac
fi

SYSTEM=$(cat lyra.md)
OUT="tests/out/$RUNNER-${MODEL//[^A-Za-z0-9._-]/_}"
mkdir -p "$OUT"

ask() {  # $1 = message; prints the reply
  case "$RUNNER" in
    claude)
      env -u CLAUDECODE -u CLAUDE_CODE_ENTRYPOINT claude -p --model "$MODEL" --max-turns 1 \
        --output-format text --system-prompt "$SYSTEM" "$1" 2>/dev/null ;;
    ollama)
      python3 - "$MODEL" "$SYSTEM" "$1" <<'PY'
import json, sys, urllib.request
model, system, user = sys.argv[1:4]
body = json.dumps({
    "model": model, "stream": False, "think": False,
    "messages": [{"role": "system", "content": system}, {"role": "user", "content": user}],
    "options": {"temperature": 0.2, "num_predict": 1500},
}).encode()
req = urllib.request.Request("http://localhost:11434/api/chat", body, {"Content-Type": "application/json"})
print(json.load(urllib.request.urlopen(req, timeout=900))["message"]["content"])
PY
      ;;
    *) echo "unknown runner: $RUNNER" >&2; exit 2 ;;
  esac
}

check() {  # $1 = expectation, $2 = reply file; prints one problem per line
  local out=$2
  case "$1" in
    optimized|detail)
      head -n 3 "$out" | grep -qE 'BASIC|DETAIL'      || echo "no mode line at the top"
      grep -q 'Optimized prompt' "$out"               || echo "no 'Optimized prompt' section (answered the prompt instead?)"
      [ "$(grep -c '^```' "$out")" -ge 2 ]            || echo "no fenced code block"
      grep -qiE 'scale of 1|rate this|how well does this' "$out" && echo "asks for a rating"
      tail -n 3 "$out" | grep -qi 'tell me if you want it shorter' || echo "missing the one-line close"
      if [ "$1" = detail ]; then
        grep -q 'Diagnosis' "$out"                    || echo "DETAIL reply has no Diagnosis"
        grep -qE 'Score' "$out"                       || echo "DETAIL reply has no Score"
      fi ;;
    greeting)
      grep -q 'Optimized prompt' "$out"               && echo "optimized instead of greeting"
      head -n 1 "$out" | grep -qiE 'say if you want|override' && echo "greeting starts with a mode line"
      grep -qi 'tell me if you want it shorter' "$out" && echo "greeting ends with the closing line"
      grep -qi 'prompt' "$out"                        || echo "greeting does not say what Lyra does"
      [ "$(grep -c . "$out")" -le 8 ]                 || echo "greeting longer than 8 lines" ;;
    *) echo "unknown expectation: $1" ;;
  esac
}

pass=0; fail=0
for f in tests/cases/*.txt; do
  name=$(basename "$f" .txt)
  if [ -n "$ONLY" ] && [[ "$name" != *"$ONLY"* ]]; then continue; fi
  expect=$(head -n 1 "$f" | sed -n 's/^expect: *//p')
  msg=$(tail -n +2 "$f" | sed '/./,$!d')
  printf '%-24s ' "$name"
  ask "$msg" > "$OUT/$name.txt"
  problems=$(check "$expect" "$OUT/$name.txt")
  if [ -z "$problems" ]; then
    echo "ok"; pass=$((pass + 1))
  else
    echo "FAIL"; printf '%s\n' "$problems" | sed 's/^/    /'; fail=$((fail + 1))
  fi
done
echo
echo "$pass passed, $fail failed. Replies in $OUT"
[ "$fail" -eq 0 ]
