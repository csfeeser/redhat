### Challenge: Automate System Status Archiving

Write a Bash script that automates the following tasks:

1. **Write Output to a File**: Save the output of `systemctl status atd` to a file named `/tmp/day1.txt`.
2. **Create a Compressed Tar Archive**: Make a compressed tar archive (`tar.gz`) of the `/tmp` directory and save it as `day1tarfile.tar.gz` in the `/home/student/` directory.
3. **Schedule the Script**: Configure this script to run every three minutes.

This script will help you practice managing system services, file compression, and scheduling with cron.

---

<details>
<summary>Click here to see the solution</summary>

```bash
#!/bin/bash

# Step 1: Write the status of 'atd' to /tmp/day1.txt
systemctl status atd > /tmp/day1.txt

# Step 2: Create a compressed tar archive of the /tmp directory
tar -czf /home/student/day1tarfile.tar.gz /tmp

# Step 3: Schedule the script to run every 3 minutes
# Use the following cron job configuration:
# */3 * * * * /path/to/your_script.sh
```

To schedule the script, add the following line to your crontab by typing `crontab -e`:

```cron
*/3 * * * * /path/to/your_script.sh
```

</details>
