# Day 2 Start-of-Class Warmup!

<img src="https://ih1.redbubble.net/image.3528575302.7254/fposter,small,wall_texture,product,750x1000.u2.jpg" width="300">

We covered a lot of content on our first day- let's see how much of it we can include in a warmup activity!

In your RHEL machines, write a bash script that automates the following:

1. Save the output of `systemctl status atd` to a file named `/tmp/day1.txt`.
   <details>
   <summary>Hint</summary>
     
   Use the redirection operator `>` to save output to a file.
   
   </details>

3. Make a tar archive named `day1tarfile.tar.gz` of the `/tmp` directory. It should be compressed with `gzip`. The tar file should be saved to the `/home/student/` directory.
   <details>
   <summary>Hint</summary>
     
   Use the `tar` command with both the `-c` (create) and `-z` (gzip) options. Specify the output file location with the `-f` option. `-v` is also nice if you want to see all your files zoom by :)
   
   </details>

5. Configure this script to run every three minutes.
   <details>
   <summary>Hint</summary>
     
   Use `crontab -e` to add a new cron job. Set the schedule by specifying `*/3 * * * *`.
   
   </details>
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
