# Startup Scripts and Systemd Services

## Objective
In this lab, students will learn to create, manage, and troubleshoot custom `systemd` services. By the end of this lab, students will be able to:
- Write a custom service and place it in `/etc/systemd/system/`.
- Enable, start, and verify the status of a custom service.
- Troubleshoot service failures using `journalctl`.
- Work with dependencies and target configurations in `systemd`.

## Procedure

**Section 1: Writing a Custom Service**

1. **Create a Script to Run as a Service**: First, create a basic script called `my_script.sh` that runs an endless loop, writing messages to a log file.

   `student@rhel:~$` 

   ```bash
   cat << 'EOF' > ~/my_script.sh
   #!/bin/bash
   while true; do
       echo "Service is running at $(date)" >> /var/log/my_service.log
       sleep 60
   done
   EOF
   ```

0. **Make the Script Executable**: Set execute permissions on the script.

   `student@rhel:~$` `chmod +x ~/my_script.sh`

0. **Create the `my_custom.service` Unit File**: Define the custom service unit file in `/etc/systemd/system/`.

   `student@rhel:~$` 

   ```bash
   sudo tee /etc/systemd/system/my_custom.service > /dev/null << EOF
   [Unit]
   Description=My Custom Service
   After=network.target

   [Service]
   ExecStart=/home/student/my_script.sh
   Restart=on-failure

   [Install]
   WantedBy=multi-user.target
   EOF
   ```

   > **Explanation**:
   > - **[Unit] Section**: Sets the description and specifies that the service should start after the `network.target` is reached.
   > - **[Service] Section**: Defines the command to start the service (`ExecStart`) and a restart policy.
   > - **[Install] Section**: Specifies that the service should be enabled for the `multi-user.target`.

   **Section 2: Enabling and Starting the Custom Service**

0. **Reload the Systemd Daemon**: Refresh `systemd` to recognize the new service.

   `student@rhel:~$` `sudo systemctl daemon-reload`

0. **Enable the Service at Boot**: Enable the service so that it starts automatically at boot.

   `student@rhel:~$` `sudo systemctl enable my_custom.service`

0. **Start the Service**: Manually start the service to test it immediately.

   `student@rhel:~$` `sudo systemctl start my_custom.service`

0. **Verify Service Status**: Check the service’s status to confirm it’s running.

   `student@rhel:~$` `sudo systemctl status my_custom.service`

   > **Note**: The output should show the service as `active (running)`. If it isn’t, examine error messages to troubleshoot.

   **Section 3: Troubleshooting Service Failures**

0. **Simulate a Failure by Introducing an Error**: Edit the `my_custom.service` file to reference an incorrect script path.

   `student@rhel:~$` `sudo vim /etc/systemd/system/my_custom.service`

   > Change `ExecStart=/home/student/my_script.sh` to `ExecStart=/home/student/non_existent_script.sh`.

0. **Reload and Restart the Service**: Reload the daemon and attempt to start the service again.

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl restart my_custom.service
   ```

0. **Check the Service Status**: Review the service status to identify any errors.

   `student@rhel:~$` `sudo systemctl status my_custom.service`

   > **Note**: The status output will indicate that the service failed due to the non-existent file path.

0. **Review Logs with `journalctl`**: Use `journalctl` to view detailed logs for the service and pinpoint the issue.

   `student@rhel:~$` `journalctl -u my_custom.service`

   > **Explanation**: `journalctl -u my_custom.service` displays logs specifically for the `my_custom.service`, making it easier to locate errors in the startup process.

0. **Restore the Correct Path**: Correct the `ExecStart` path in the unit file, reload the daemon, and restart the service.

   ```bash
   sudo vim /etc/systemd/system/my_custom.service
   sudo systemctl daemon-reload
   sudo systemctl restart my_custom.service
   ```

   **Section 4: Adding Dependencies and Configuring Targets**

0. **Add a Dependency**: Modify `my_custom.service` to depend on another target, such as `network-online.target`.

   ```bash
   sudo tee /etc/systemd/system/my_custom.service > /dev/null << EOF
   [Unit]
   Description=My Custom Service with Network Dependency
   After=network-online.target
   Wants=network-online.target

   [Service]
   ExecStart=/home/student/my_script.sh
   Restart=on-failure

   [Install]
   WantedBy=multi-user.target
   EOF
   ```

   > **Explanation**:
   > - **After=network-online.target**: Ensures this service starts only after the network is fully online.
   > - **Wants=network-online.target**: Indicates a soft dependency on `network-online.target` without failing if it isn’t met.

0. **Reload and Start the Service**: Apply changes by reloading `systemd` and starting the service.

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl restart my_custom.service
   ```

0. **Check Service Behavior**: Confirm that the service starts only after the network is online by inspecting its status and viewing related logs.

   `student@rhel:~$` `sudo systemctl status my_custom.service`

   **Conclusion**

In this lab, you learned:
- How to create a custom `systemd` service and place it in `/etc/systemd/system/`.
- How to enable, start, and check the status of the custom service.
- Techniques for troubleshooting and correcting service failures.
- How to add dependencies to your service to control when it starts.

These skills help ensure that services run reliably and in the proper sequence on RHEL systems.

**Extra Practice: Create a Simple Custom Service** 🛠️

**Objective**:  
Create a custom `systemd` service that runs a simple script on boot.

1. Write a script that logs a message to `/var/log/custom_startup.log` every minute.
2. Define a `my_startup.service` unit file to execute the script.

<details>
<summary>Click here for a hint!</summary>

1. Place your script in your home directory and make it executable.
2. Ensure `ExecStart` in the unit file points to the script location.

</details>

<details>
<summary>Click here for the solution</summary>

1. Create the script:
   ```bash
   cat << 'EOF' > ~/my_startup_script.sh
   #!/bin/bash
   while true; do
       echo "Startup service running at $(date)" >> /var/log/custom_startup.log
       sleep 60
   done
   EOF
   chmod +x ~/my_startup_script.sh
   ```

2. Define the `my_startup.service` file:
   ```bash
   sudo tee /etc/systemd/system/my_startup.service > /dev/null << EOF
   [Unit]
   Description=Custom Startup Service

   [Service]
   ExecStart=/home/student/my_startup_script.sh
   Restart=on-failure

   [Install]
   WantedBy=multi-user.target
   EOF
   ```

3. Enable and start the service:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable my_startup.service
   sudo systemctl start my_startup.service
   ```

4. Verify that logs are written to `/var/log/custom_startup.log`:
   ```bash
   tail -f /var/log/custom_startup.log
   ```

5. Clean up by stopping and disabling the service:
   ```bash
   sudo systemctl stop my_startup.service
   sudo systemctl disable my_startup.service
   ```

</details>