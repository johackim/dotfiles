#!/bin/bash

SESSION="second"

if tmux has-session -t "$SESSION" 2>/dev/null; then
    exec tmux attach-session -t "$SESSION"
fi

tmux new-session -d -s "$SESSION" -n editor -c "$HOME"

tmux send-keys -t "$SESSION:editor.0" 'clear' C-m

exec tmux attach-session -t "$SESSION"
