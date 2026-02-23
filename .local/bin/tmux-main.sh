#!/bin/bash

SESSION="main"
LAYOUT="bf10,174x49,0,0{86x49,0,0[86x41,0,0,0,86x7,0,42,1],87x49,87,0[87x32,87,0,2,87x14,87,33,3,87x1,87,48,4]}"

if tmux has-session -t "$SESSION" 2>/dev/null; then
    exec tmux attach-session -t "$SESSION"
fi

tmux new-session -d -s "$SESSION" -n main -c "$HOME"

tmux split-window -t "$SESSION:main"
tmux split-window -t "$SESSION:main"
tmux split-window -t "$SESSION:main"
tmux split-window -t "$SESSION:main"

tmux select-layout -t "$SESSION:main" "$LAYOUT"

tmux send-keys -t "$SESSION:main.0" 'clear;fastfetch' C-m
tmux send-keys -t "$SESSION:main.1" 'clear' C-m
tmux send-keys -t "$SESSION:main.2" 'htop' C-m
tmux send-keys -t "$SESSION:main.3" 'monitor' C-m

exec tmux attach-session -t "$SESSION"
