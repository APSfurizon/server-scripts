#!/bin/bash

SESSION="Main"
WORKDIR="/home/webint"

# Check if session already exists
tmux has-session -t $SESSION 2>/dev/null
if [ $? == 0 ]; then
  echo "Session '$SESSION' already exists. Exiting."
  exit 1
fi

# Create new session with default directory
tmux new-session -d -s $SESSION -c $WORKDIR -n backend

# Create second window "db"
tmux new-window -t $SESSION:1 -n db -c $WORKDIR

# Create third window "logs"
tmux new-window -t $SESSION:2 -n logs -c $WORKDIR

# Split into 4 horizontal panes
tmux split-window -t $SESSION:2 -c $WORKDIR
tmux split-window -t $SESSION:2 -c $WORKDIR
tmux split-window -t $SESSION:2 -c $WORKDIR

# Adjust pane sizes (example: evenly distribute)
#tmux select-layout -t $SESSION:3 even-vertical
tmux resize-window -t $SESSION:2 -y 66
tmux resize-pane -t $SESSION:2.0 -y 14
tmux resize-pane -t $SESSION:2.1 -y 23
tmux resize-pane -t $SESSION:2.2 -y 13
tmux resize-pane -t $SESSION:2.3 -y 13
tmux set-option -t $SESSION:2 -u window-size

# Create fourth window "frontend"
tmux new-window -t $SESSION:3 -n frontend -c $WORKDIR

tmux select-window -t $SESSION:2
tmux select-pane -t $SESSION:2.1

echo "Waiting for pretix.service to become active..."
while ! systemctl is-active --quiet pretix.service; do
  echo "sleep"
  sleep 10
done
sleep 1
# Send commands to each pane
tmux send-keys -t $SESSION:0.0 "cd /home/webint/fz-backend" C-m "cd /root/pretix-custom-image/" C-m "cd -" C-m "clear" C-m
tmux send-keys -t $SESSION:1.0 "cd /home/webint/fz-backend" C-m "clear" C-m "./connectToDb.sh" C-m
tmux send-keys -t $SESSION:2.0 "htop" C-m
tmux send-keys -t $SESSION:2.1 "cd /home/webint/fz-backend" C-m "./attachLoop.sh" C-m
tmux send-keys -t $SESSION:2.2 "tail -F /var/log/nginx/access.log" C-m
tmux send-keys -t $SESSION:2.3 "tail -F /var/pretix-data/logs/pretix.log" C-m
tmux send-keys -t $SESSION:3.0 "cd /home/webint/fz-frontend" C-m "clear" C-m
