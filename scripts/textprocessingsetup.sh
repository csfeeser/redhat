#!/bin/bash

# Create the log_files directory
mkdir -p log_files

# Create sample log files with entries that include "Error" for testing

# File: app1.log
cat <<EOL > log_files/app1.log
2024-10-01 12:00:00 Info: Application started successfully
2024-10-01 12:05:00 Error: Failed to connect to database
2024-10-01 12:10:00 Warning: Disk space running low
2024-10-01 12:15:00 Error: Unexpected shutdown detected
EOL

# File: app2.log
cat <<EOL > log_files/app2.log
2024-10-02 09:00:00 Info: Application updated to version 1.1
2024-10-02 09:30:00 Error: Failed to initialize module
2024-10-02 09:45:00 Critical: Overload detected in processor
2024-10-02 10:00:00 Error: Timeout while waiting for response
EOL

# File: app3.log
cat <<EOL > log_files/app3.log
2024-10-03 08:00:00 Info: Daily backup completed
2024-10-03 08:30:00 Error: Permission denied during file access
2024-10-03 09:00:00 Info: User login detected
2024-10-03 09:15:00 Error: Service restart failed
EOL

echo "Setup complete. Directory 'log_files' and sample log files (app1.log, app2.log, app3.log) have been created."
