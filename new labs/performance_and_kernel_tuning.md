# Performance and Kernel Tuning

## Objective
In this lab, students will learn basic performance tuning techniques and explore kernel parameters for optimizing system performance, focusing on memory, CPU, and network settings. By the end of the lab, students will be able to:
- Adjust kernel parameters with `sysctl` to tune memory and network settings.
- Configure persistent tuning by editing `/etc/sysctl.conf`.
- Tune CPU and memory usage through kernel settings in `/proc/sys/`.
- Use monitoring tools to observe the impact of tuning changes.

## Procedure

**Section 1: Modifying Kernel Parameters with `sysctl`**

1. **View Current Kernel Parameters**: Begin by listing a few current kernel parameters related to memory and network configurations.

   `student@rhel:~$` `sysctl -a | grep -E 'vm.swappiness|net.ipv4.ip_forward'`

   > **Explanation**: 
   > - **vm.swappiness**: Controls the tendency of the kernel to swap memory pages. Lower values reduce swap use.
   > - **net.ipv4.ip_forward**: Enables or disables packet forwarding across interfaces, useful in routing scenarios.

0. **Adjust `vm.swappiness`**: Change the `vm.swappiness` value to **10** to reduce swap usage.

   `student@rhel:~$` `sudo sysctl -w vm.swappiness=10`

0. **Enable IP Forwarding**: Enable IPv4 forwarding by setting `net.ipv4.ip_forward` to **1**.

   `student@rhel:~$` `sudo sysctl -w net.ipv4.ip_forward=1`

0. **Verify Changes**: Confirm that the changes took effect by re-checking these parameters.

   `student@rhel:~$` `sysctl -a | grep -E 'vm.swappiness|net.ipv4.ip_forward'`

   > **Note**: These changes are temporary and will revert after a reboot. In Section 2, you’ll learn to make these changes persistent.

   **Section 2: Persistent Kernel Tuning with `sysctl.conf`**

0. **Open the `sysctl.conf` File**: Edit `/etc/sysctl.conf` to make kernel tuning adjustments persistent across reboots.

   `student@rhel:~$` `sudo vim /etc/sysctl.conf`

0. **Add Persistent Tuning Settings**: Append the following lines to configure `vm.swappiness` and enable IP forwarding persistently.

   ```
   vm.swappiness=10
   net.ipv4.ip_forward=1
   ```

0. **Apply the New Settings**: Use `sysctl -p` to load the settings from `sysctl.conf` immediately.

   `student@rhel:~$` `sudo sysctl -p`

0. **Verify Changes**: Confirm that the values persist by listing them again.

   `student@rhel:~$` `sysctl -a | grep -E 'vm.swappiness|net.ipv4.ip_forward'`

   > **Explanation**: Editing `/etc/sysctl.conf` ensures that these parameters are set on every boot.

   **Section 3: CPU and Memory Tuning with `/proc/sys/`**

0. **Check Current CPU Scheduling Priorities**: View the current values in `/proc/sys/kernel/` related to CPU scheduling.

   `student@rhel:~$` `cat /proc/sys/kernel/sched_child_runs_first`

   > **Note**: The `sched_child_runs_first` parameter can prioritize child processes, which may benefit certain workloads.

0. **Adjust Memory Overcommit Handling**: Configure memory overcommit behavior by setting the `vm.overcommit_memory` parameter.

   `student@rhel:~$` `echo 1 | sudo tee /proc/sys/vm/overcommit_memory`

   > **Explanation**:
   > - **0**: Heuristic overcommit handling (default).
   > - **1**: Always overcommit, useful for memory-intensive applications.
   > - **2**: No overcommit unless there’s enough memory, for systems needing stability.

0. **Set Persistent Overcommit Handling**: Add the parameter to `/etc/sysctl.conf` to make it persistent.

   ```
   vm.overcommit_memory=1
   ```

0. **Apply Changes and Verify**: Reload `sysctl.conf` and verify the settings.

   ```bash
   sudo sysctl -p
   sysctl vm.overcommit_memory
   ```

   **Section 4: Monitoring and Measuring Impact**

0. **Install Monitoring Tools**: If not already installed, add tools like `iostat` from the `sysstat` package to monitor system performance.

   `student@rhel:~$` `sudo yum install -y sysstat`

0. **Monitor CPU and Memory with `top`**: Use `top` to monitor CPU and memory usage in real time. Sort by CPU usage by pressing `Shift+P`.

   `student@rhel:~$` `top`

   > **Tip**: Note the impact of your tuning changes on CPU and memory utilization.

0. **Use `iostat` for Disk and CPU I/O**: Run `iostat` to monitor CPU and disk I/O activity over 5-second intervals.

   `student@rhel:~$` `iostat -x 5`

0. **Simulate Workload and Measure Impact**: Run a script that generates a CPU load to observe how the system behaves with your tuning changes.

   ```bash
   cat << 'EOF' > ~/cpu_stress.sh
   #!/bin/bash
   while true; do
       echo $((2**100000)) > /dev/null
   done
   EOF
   chmod +x ~/cpu_stress.sh
   ./cpu_stress.sh &
   ```

   > **Note**: Run `top` and `iostat` while the stress test is active to observe the impact.

0. **Clean Up**: Kill the stress test after observing performance.

   `student@rhel:~$` `pkill -f cpu_stress.sh`

 **Conclusion**

In this lab, you explored:
- Adjusting kernel parameters with `sysctl`.
- Persisting kernel tuning changes by configuring `/etc/sysctl.conf`.
- Modifying CPU and memory settings in `/proc/sys/`.
- Monitoring and verifying performance changes with `top` and `iostat`.

**Extra Practice: Configure Memory Swappiness and Verify** 🛠️

**Objective**:  
Set `vm.swappiness` to 5, persist the change, and verify it.

1. **Set the Swappiness Value**:
   ```bash
   sudo sysctl -w vm.swappiness=5
   ```

2. **Edit `/etc/sysctl.conf`** to make the change persistent:
   ```bash
   echo "vm.swappiness=5" | sudo tee -a /etc/sysctl.conf
   ```

3. **Apply and Verify**:
   ```bash
   sudo sysctl -p
   sysctl vm.swappiness
   ```

<details>
<summary>Click here for a hint!</summary>

1. `sysctl -w` applies changes temporarily.
2. Edit `/etc/sysctl.conf` to make changes persistent.

</details>

<details>
<summary>Click here for the solution</summary>

1. Set swappiness to **5** temporarily:
   ```bash
   sudo sysctl -w vm.swappiness=5
   ```

2. Add the setting to `/etc/sysctl.conf`:
   ```bash
   echo "vm.swappiness=5" | sudo tee -a /etc/sysctl.conf
   ```

3. Apply and confirm the change:
   ```bash
   sudo sysctl -p
   sysctl vm.swappiness
   ```

</details>