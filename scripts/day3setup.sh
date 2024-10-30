#!/bin/bash

# Change tuned profile to "balanced"
tuned-adm profile balanced

# Disable SELinux persistently
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

# Start a high CPU usage process named "big-ol-cpu-burner"
bash -c 'exec -a big-ol-cpu-burner dd if=/dev/zero of=/dev/null' &

# Start a low CPU usage process named "lil-ol-me"
bash -c 'exec -a lil-ol-me sleep 1000' &
