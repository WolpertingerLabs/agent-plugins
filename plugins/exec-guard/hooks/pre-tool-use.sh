#!/bin/bash

# Exec Guard - Pre-Tool-Use Hook
# Guards against:
#   1. Reading/editing/writing files that match .gitignore patterns
#   2. Running prohibited programs via Bash
#
# Actions are configurable per category: "deny" (hard block) or "ask" (require user approval)

set -euo pipefail

CONFIG_FILE="${CLAUDE_PLUGIN_ROOT}/exec-guard.config.json"
HOOK_INPUT=$(cat)

TOOL_NAME=$(echo "$HOOK_INPUT" | jq -r '.tool_name')
TOOL_INPUT=$(echo "$HOOK_INPUT" | jq -r '.tool_input')

# Emit a PreToolUse hook response with the configured action
# $1 = action ("deny" or "ask"), $2 = reason string
emit_decision() {
  local action="$1"
  local reason="$2"

  jq -n \
    --arg action "$action" \
    --arg reason "$reason" \
    '{
      "hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": $action,
        "permissionDecisionReason": $reason
      }
    }'
  exit 0
}

# Read an action from config, defaulting to "ask"
read_action() {
  local key="$1"
  local default="${2:-ask}"
  if [[ -f "$CONFIG_FILE" ]]; then
    local val
    val=$(jq -r --arg k "$key" '.[$k] // empty' "$CONFIG_FILE" 2>/dev/null)
    if [[ "$val" == "deny" || "$val" == "ask" ]]; then
      echo "$val"
      return
    fi
  fi
  echo "$default"
}

# --- Gitignore check for file-access tools ---

check_gitignore() {
  local file_path="$1"

  # Skip if empty or not in a git repo
  if [[ -z "$file_path" ]] || [[ "$file_path" == "null" ]]; then
    return 0
  fi

  # Check if we're in a git repo
  if ! git rev-parse --show-toplevel &>/dev/null; then
    return 0
  fi

  # git check-ignore exits 0 if the path IS ignored, 1 if not
  if git check-ignore -q "$file_path" 2>/dev/null; then
    local action
    action=$(read_action "gitignore_action" "ask")
    emit_decision "$action" "EXEC GUARD: Access to gitignored file: $file_path. This file is excluded by .gitignore and should not normally be accessed by agents."
  fi
}

case "$TOOL_NAME" in
  Read|Edit|Write)
    FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty')
    check_gitignore "$FILE_PATH"
    ;;

  Glob)
    GLOB_PATH=$(echo "$TOOL_INPUT" | jq -r '.path // empty')
    if [[ -n "$GLOB_PATH" ]] && [[ "$GLOB_PATH" != "null" ]]; then
      check_gitignore "$GLOB_PATH"
    fi
    ;;

  Grep)
    GREP_PATH=$(echo "$TOOL_INPUT" | jq -r '.path // empty')
    if [[ -n "$GREP_PATH" ]] && [[ "$GREP_PATH" != "null" ]]; then
      check_gitignore "$GREP_PATH"
    fi
    ;;

  Bash)
    COMMAND=$(echo "$TOOL_INPUT" | jq -r '.command // empty')

    if [[ -z "$COMMAND" ]]; then
      exit 0
    fi

    # Load prohibited programs from config
    if [[ ! -f "$CONFIG_FILE" ]]; then
      exit 0
    fi

    mapfile -t PROHIBITED < <(jq -r '.prohibited_programs[]' "$CONFIG_FILE" 2>/dev/null)

    if [[ ${#PROHIBITED[@]} -eq 0 ]]; then
      exit 0
    fi

    local_action=$(read_action "prohibited_program_action" "deny")

    for prog in "${PROHIBITED[@]}"; do
      if echo "$COMMAND" | grep -qwF "$prog"; then
        emit_decision "$local_action" "EXEC GUARD: Prohibited program detected: $prog. This program is on the deny list. Command: $COMMAND"
      fi
    done
    ;;
esac

# Allow by default (no output = allow)
exit 0
