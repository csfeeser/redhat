#!/bin/bash

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
RESET="\033[0m"

# Helper function to print results
print_result() {
  local task=$1
  local objective=$2
  local passed=$3
  if [ "$passed" -eq 1 ]; then
    echo -e "${GREEN}$task: 100/100 - $objective${RESET}"
    score=$((score + 25))
  else
    echo -e "${RED}$task: 0/100 - $objective${RESET}"
  fi
}

# Initial score
score=0

# Task 1: Check for high-CPU processes
echo "Checking for high-CPU processes..."
cpu_process=$(ps aux --sort=-%cpu | awk 'NR==2{if ($3>50) print $2}')
if [ -z "$cpu_process" ]; then
  print_result "High-CPU Process Check" "Process Management and Control" 1
else
  print_result "High-CPU Process Check" "Process Management and Control" 0
fi

# Task 2: Verify SELinux is enforcing and persistent
echo "Checking SELinux mode..."
current_selinux_mode=$(getenforce)
config_selinux_mode=$(grep "^SELINUX=enforcing" /etc/selinux/config)

if [ "$current_selinux_mode" == "Enforcing" ] && [ -n "$config_selinux_mode" ]; then
  print_result "SELinux Enforcing Check" "Security Settings and Enforcement" 1
else
  print_result "SELinux Enforcing Check" "Security Settings and Enforcement" 0
fi

# Task 3: Check if tuned profile is set to recommended
echo "Checking tuned-adm recommended profile..."
recommended_profile=$(tuned-adm recommend)
current_profile=$(tuned-adm active | awk '{print $NF}')

if [ "$current_profile" == "$recommended_profile" ]; then
  print_result "Tuned Profile Check" "System Performance Optimization" 1
else
  print_result "Tuned Profile Check" "System Performance Optimization" 0
fi

# Task 4: Check if cron process has priority 10
echo "Checking cron process priority..."
cron_pid=$(pgrep cron)
cron_priority=$(ps -o ni -p "$cron_pid" | awk 'NR==2{print $1}')

if [ "$cron_priority" -eq 10 ]; then
  print_result "Cron Process Priority Check" "Process Priority Adjustment" 1
else
  print_result "Cron Process Priority Check" "Process Priority Adjustment" 0
fi

# Final score
echo -e "\nFinal Score: $score/100"
