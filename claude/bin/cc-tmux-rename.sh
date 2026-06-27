#!/usr/bin/env bash
# Rename the current tmux window after the FIRST user prompt of a Claude Code
# session, then lock the name so tmux's automatic-rename stops overriding it.
#
# Two-stage naming:
#   1. Synchronous: set an instant deterministic slug from the prompt so the
#      window is named the moment you hit enter (no latency on the prompt).
#   2. Background: ask a cheap model for a tidy 2-4 word title and re-rename when
#      it returns (~seconds later). Never blocks prompt submission.
#
# Wired as a UserPromptSubmit hook in ~/.claude/settings.json. The hook fires on
# every prompt, so we use a per-window sentinel (@cc_named) to act only once.
# Reads the hook JSON payload on stdin; needs $TMUX_PANE in the environment.
set -euo pipefail

# Nothing to do outside tmux.
[[ -n "${TMUX:-}" && -n "${TMUX_PANE:-}" ]] || exit 0

# The window this pane belongs to.
window=$(tmux display-message -p -t "$TMUX_PANE" '#{window_id}' 2>/dev/null) || exit 0
[[ -n "$window" ]] || exit 0

# Act only on the first prompt — bail if we've already named this window.
already=$(tmux show-options -wqv -t "$window" '@cc_named' 2>/dev/null || true)
[[ "$already" == "1" ]] && exit 0

# Pull the prompt text from the hook payload (fall back to raw stdin).
payload=$(cat)
prompt=$(printf '%s' "$payload" | jq -r '.prompt // empty' 2>/dev/null || true)
[[ -z "$prompt" ]] && prompt="$payload"

# Shared slugifier: lowercase, keep alnum, collapse the rest to single dashes,
# trim whitespace, cap length. Arg 2 is the char cap (default 24).
slugify() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | tr -c 'a-z0-9' ' ' \
    | awk '{$1=$1; print}' \
    | cut -c1-"${2:-24}" \
    | awk '{$1=$1; print}' \
    | tr ' ' '-'
}

# Stage 1 — instant placeholder from the raw prompt.
slug=$(slugify "$prompt" 30)

# Empty prompt (e.g. an image-only message) — leave auto-naming in place and
# retry on the next prompt.
[[ -z "$slug" ]] && exit 0

# Lock the name: disable automatic-rename for this window, set the name, mark it.
tmux set-option -w -t "$window" automatic-rename off
tmux rename-window -t "$window" "$slug"
tmux set-option -w -t "$window" '@cc_named' 1

# Stage 2 — background: upgrade to a model-generated title. Detached so the
# prompt submits with zero added latency. Resolve the real binary (hooks run
# without shell aliases). Skip silently if it isn't found.
claude_bin=""
for c in "$HOME/.toolbox/bin/claude" "$(command -v claude 2>/dev/null || true)"; do
  [[ -n "$c" && -x "$c" ]] && { claude_bin="$c"; break; }
done
[[ -z "$claude_bin" ]] && exit 0

(
  sys='You generate tmux window titles. Reply with ONLY a 2-4 word kebab-case title (lowercase, hyphens, no quotes, no explanation) summarizing the task.'
  title=$(printf '%s\n\nTask: %s' "$sys" "$prompt" \
    | "$claude_bin" -p --model haiku 2>/dev/null \
    | head -1) || exit 0
  title=$(slugify "$title" 24)
  [[ -z "$title" ]] && exit 0
  # Only upgrade if the window still carries our placeholder slug — don't stomp a
  # window the user has since renamed by hand or repurposed.
  current=$(tmux show-options -wqv -t "$window" @cc_named 2>/dev/null || true)
  [[ "$current" == "1" ]] || exit 0
  tmux rename-window -t "$window" "$title" 2>/dev/null || true
) >/dev/null 2>&1 &

exit 0
