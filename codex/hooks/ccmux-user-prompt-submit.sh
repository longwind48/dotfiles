#!/bin/bash
# ccmux 1.1.0 does not mark the start of Codex turns or automatic goal
# continuations, so its idle marker otherwise remains stale until the turn ends.
MARKERS_DIR="${CCMUX_HOME:-$HOME/.config/ccmux}/session-pids"

INPUT=$(cat)
eval "$(printf '%s' "$INPUT" | jq -r '
  @sh "SESSION_ID=\(.session_id // "")",
  @sh "TRANSCRIPT_PATH=\(.transcript_path // "")"
' 2>/dev/null)"
[ -n "$SESSION_ID" ] || exit 0

MARKER_FILE="$MARKERS_DIR/codex-$SESSION_ID.json"
if [ -f "$MARKER_FILE" ]; then
  jq '. + {state: "working", state_timestamp: now, pending_tool: null, permission_context: null}' \
    "$MARKER_FILE" > "$MARKER_FILE.tmp" 2>/dev/null &&
    mv "$MARKER_FILE.tmp" "$MARKER_FILE" 2>/dev/null
else
  CODEX_TTY=$(ps -p "$PPID" -o tty= 2>/dev/null | tr -d ' ')
  mkdir -p "$MARKERS_DIR" 2>/dev/null || exit 0
  jq -nc \
    --arg pid "$PPID" \
    --arg tty "${CODEX_TTY:-unknown}" \
    --arg session_id "$SESSION_ID" \
    --arg transcript_path "$TRANSCRIPT_PATH" \
    '{agent_type: "codex", pid: ($pid|tonumber), tty: $tty, session_id: $session_id, transcript_path: (if $transcript_path == "" then null else $transcript_path end), state: "working", state_timestamp: now, timestamp: now}' \
    > "$MARKER_FILE.tmp" 2>/dev/null &&
    mv "$MARKER_FILE.tmp" "$MARKER_FILE" 2>/dev/null
fi

exit 0
