# RHEL9 vs. RHEL7 and RHEL8

## Objective
In this lab, students will learn to identify and work with the differences in `systemd` functionality across RHEL7, RHEL8, and RHEL9. By the end of the lab, students will:
- Recognize the evolution of `systemd` commands and features between RHEL versions.
- Practice using new `systemd` commands in RHEL9.
- Understand changes in unit dependencies and defaults that impact system behavior.
- Identify deprecated `systemd` features from RHEL7 and RHEL8.

## Procedure

**Section 1: Reviewing the Evolution of `systemd`**

0. **Check the `systemd` Version**: Confirm which `systemd` version is installed on your system.
   
   `student@rhel:~$` `systemctl --version`

   > **Note**: RHEL7 typically uses an older `systemd` version (219), while RHEL9 uses an updated version (e.g., 239+), which includes new options and behaviors.

0. **Identify `systemd` Features by Version**: Run the following commands to explore new options available in RHEL9’s `systemd`.

   ```bash
   man systemctl  # Scroll through to see new options exclusive to RHEL9
   ```

    **Section 2: Practicing New `systemd` Commands in RHEL9**

0. **Explore New `systemctl` Options**: Test commands introduced in newer RHEL versions, such as `systemctl edit` and `systemctl show`.

   `student@rhel:~$` `systemctl edit my_custom.service`

   > This command allows you to modify a unit file without directly editing it, preserving changes in a drop-in file.

0. **Using `systemctl show`**: View detailed properties of a running service.

   `student@rhel:~$` `systemctl show sshd`

   > The `show` command lists all parameters of the specified service. Use this to explore configurations without navigating configuration files.

0. **Optional - Experiment with `systemd-resolved`**: Some RHEL9 versions use `systemd-resolved` for DNS management, a feature missing in RHEL7.

   ```bash
   systemctl status systemd-resolved
   ```

   > **Note**: If enabled, this service provides DNS caching and other management functions.

    **Section 3: Reviewing Unit Dependency Changes in RHEL9**

0. **Analyze Dependencies**: Run the following to list dependencies for a core service like `sshd`.

   `student@rhel:~$` `systemctl list-dependencies sshd`

   > **Note**: Notice how `systemd` dependencies have changed across versions, with some services moving from `multi-user.target` to `graphical.target` in RHEL9.

0. **Examine Default Target Changes**: Review the default target for your system using the command below:

   `student@rhel:~$` `systemctl get-default`

   > RHEL9 often sets the `multi-user.target` as the default for server setups. Compare this with RHEL7, where defaults might vary.

    **Section 4: Analyzing Deprecated Features**

0. **Identify Deprecated `systemd` Options**: Check for deprecated commands by running `journalctl` with various flags that may be unsupported.

   `student@rhel:~$` `journalctl --no-pager --output=cat`

   > Some RHEL7 `journalctl` options are deprecated or behave differently in RHEL9.

0. **Verify Legacy Unit Syntax**: Attempt to enable legacy `systemd` syntax for service commands. For instance, in RHEL7, `chkconfig` was often used alongside `systemd`, whereas RHEL9 fully removes this integration.

   ```bash
   systemctl enable my_custom.service  # Confirm functionality in RHEL9
   ```

To make this lab more comprehensive, we could add a couple of sections to further explore `systemd` features and version-specific changes in RHEL9. Here are additional sections that could be included:

    **Section 5: Advanced Systemd Targets and Isolation**

0. **Explore Systemd Targets**: Have students list all available targets in `systemd` to understand different system states.
   
   `student@rhel:~$` `systemctl list-units --type=target`

   > **Note**: This command provides an overview of targets like `multi-user.target`, `graphical.target`, and `rescue.target`, which organize services into different operational states.

0. **Switching Targets and Isolating States**: Practice switching targets. For example, isolate the system to `rescue.target` and observe the change.
   
   `student@rhel:~$` `sudo systemctl isolate rescue.target`

   > **Caution**: `isolate` transitions the system to a new target, shutting down conflicting services. Ensure your work is saved before proceeding.

0. **Return to the Default Target**: After exploring the `rescue.target`, return to the default target.

   `student@rhel:~$` `sudo systemctl isolate multi-user.target`

    **Section 6: Logging with Systemd and `journalctl`**

0. **Explore `journalctl` Logs**: Use `journalctl` to view logs for specific services, filtering by date and priority.

   `student@rhel:~$` `journalctl -u sshd --since "1 hour ago"`

   > **Note**: This command displays `sshd` service logs from the last hour. Filtering logs is crucial for troubleshooting.

0. **Set Persistent Logging**: Confirm or set persistent logging by checking and configuring the `journald.conf` file.

   ```bash
   sudo vim /etc/systemd/journald.conf  # Set Storage=persistent if not already
   sudo systemctl restart systemd-journald
   ```

   > **Explanation**: Persistent logging saves logs to disk, which is essential for retaining logs across reboots. This setting is often enabled by default in RHEL8/9.

0. **Review Logs by Priority**: Display only critical logs using the `journalctl` priority filter.

    `student@rhel:~$` `journalctl -p crit`

    **Section 7: Systemd Timer Units for Task Scheduling**

0. **Create a Timer for a Recurring Task**: Demonstrate how to schedule tasks using `systemd` timers, a replacement for traditional cron jobs in newer RHEL versions.

   `student@rhel:~$` `sudo vim /etc/systemd/system/backup.service`

   ```ini
   [Unit]
   Description=Daily Backup Task

   [Service]
   Type=simple
   ExecStart=/usr/bin/backup_script.sh
   ```

0. **Define the Timer Unit**: Configure a timer to execute the service daily.

   `student@rhel:~$` `sudo vim /etc/systemd/system/backup.timer`

   ```ini
   [Unit]
   Description=Runs backup.service daily

   [Timer]
   OnCalendar=daily
   Persistent=true

   [Install]
   WantedBy=timers.target
   ```

0. **Start and Enable the Timer**: Start the timer and enable it to persist across reboots.

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl start backup.timer
   sudo systemctl enable backup.timer
   ```

   > **Explanation**: Timers provide a robust alternative to `cron` for scheduled tasks, with better integration into `systemd` logging and management.

0. **Verify Timer Status**: Check the status and next runtime of the timer.

   `student@rhel:~$` `systemctl list-timers --all`

**Conclusion**

In this lab, you explored:
- `systemd`'s evolution across RHEL versions.
- New RHEL9 commands and features that improve service management.
- Changes in service dependencies and system targets that affect startup.
- Deprecated options from older RHEL versions.
