## **Day 3 Warmup Challenge**

<img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8bxMDIiZSpmwuOIfUu1KmuacChGL0V-rZ8A&s" width="300">

Here are a few quick tasks that are similar to what you might encounter on the RHCSA exam! Chad has already snuck into your machines and committed some shenanigans 😈

**RUN THIS FIRST:**

```bash
sudo yum install wget -y
cd && wget -qO day3setup.sh https://raw.githubusercontent.com/csfeeser/redhat/refs/heads/main/scripts/day3setup.sh && sudo bash day3setup.sh
```

1. Find the process consuming the most CPU on your machine. Kill this process.

   <details>
   <summary>Click here for the solution</summary>

   Use `top` or `ps` to find the process with the highest CPU usage:

   ```bash
   top
   ```

   Find the highest CPU usage process and note the PID. Then kill it with:

   ```bash
   sudo kill <PID>
   ```
   
   </details>

0. Verify that SELinux is set to **enforcing** mode and ensure this configuration persists across reboots.

   <details>
   <summary>Click here for the solution</summary>

   First, check the current SELinux mode:

   ```bash
   getenforce
   ```

   If it’s not in enforcing mode, set it temporarily:

   ```bash
   sudo setenforce 1
   ```

   To make it persistent, edit the SELinux configuration file:

   ```bash
   sudo vi /etc/selinux/config
   ```

   Change the line to:

   ```bash
   SELINUX=enforcing
   ```

   Save and exit. This will ensure SELinux remains in enforcing mode across reboots.
   
   </details>

0. Use `tuned-adm` to set your system to the recommended profile.

   <details>
   <summary>Click here for the solution</summary>

   Find the recommended profile with:

   ```bash
   tuned-adm recommend
   ```

   Then set it as the active profile:

   ```bash
   sudo tuned-adm profile <recommended-profile>
   ```

   Replace `<recommended-profile>` with the suggested profile name.
   
   </details>

0. Find the **`cron`** process running on your system, and **renice** it to a priority level of `10`.

   <details>
   <summary>Click here for the solution</summary>

   Find the `cron` process ID:

   ```bash
   ps aux | grep cron
   ```

   Note the PID, then renice it to `10`:

   ```bash
   sudo renice 10 -p <PID>
   ```

   Replace `<PID>` with the actual process ID of `cron`.
   
   </details>

## Run this command to check your work!
`cd && wget -qO day3confirmation.sh https://raw.githubusercontent.com/csfeeser/redhat/refs/heads/main/scripts/day3confirmation.sh && sudo bash day3confirmation.sh`





















   
