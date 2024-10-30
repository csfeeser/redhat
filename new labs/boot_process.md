# Boot-Up Process, Single-User Mode, and System Recovery

## Objective
In this lab, students will learn about the Linux boot process and practice basic system recovery techniques using GRUB2. By the end of this lab, students will be able to:
- Identify and describe each stage of the Linux boot process.
- Edit GRUB boot parameters to troubleshoot boot issues.
- Enter single-user mode and perform recovery tasks.
- Reinstall GRUB in recovery scenarios.

## Procedure

**Section 1: Exploring the Boot Process Stages**

1. **List Boot Stages**: Begin by examining the different stages of the Linux boot process. Here’s an outline to get familiar with each stage:
   - **BIOS/UEFI**: Initializes hardware and hands control to the bootloader.
   - **GRUB**: Loads kernel and initramfs, providing the boot menu.
   - **Kernel**: Initializes hardware and mounts the root filesystem.
   - **Init/Systemd**: Starts systemd targets and services.

0. **View Kernel Messages with `dmesg`**: Use `dmesg` to review kernel messages from the most recent boot.

   `student@rhel:~$` `dmesg | less`

   > **Note**: `dmesg` provides a log of kernel messages. Scroll through to identify events that correspond to each boot stage.

   **Section 2: Editing Boot Parameters in GRUB**

0. **Modify GRUB Configuration**: Edit the `/etc/default/grub` file to add boot parameters that control boot behavior.
   
   `student@rhel:~$` `sudo vim /etc/default/grub`

0. **Add Kernel Parameters**: Add the following parameters to the `GRUB_CMDLINE_LINUX` line to enable a quieter boot experience:

   ```
   GRUB_CMDLINE_LINUX="quiet splash"
   ```

   > **Explanation**:
   > - **quiet**: Suppresses non-critical boot messages.
   > - **splash**: Displays a graphical boot screen if available.

0. **Update GRUB Configuration**: After modifying `/etc/default/grub`, update the GRUB configuration to apply changes.

   `student@rhel:~$` `sudo grub2-mkconfig -o /boot/grub2/grub.cfg`

   > **Note**: This command regenerates `grub.cfg` to include new parameters.

   **Section 3: Simulating and Recovering from Boot Failures**

0. **Intentionally Modify GRUB to Cause a Boot Failure**: Edit `/etc/default/grub` to add an invalid parameter in `GRUB_CMDLINE_LINUX`.

   ```bash
   GRUB_CMDLINE_LINUX="invalid_param"
   ```

0. **Rebuild GRUB Configuration**:

   `student@rhel:~$` `sudo grub2-mkconfig -o /boot/grub2/grub.cfg`

0. **Reboot and Observe the Error**: Reboot the system and observe the behavior when the system attempts to boot with an invalid parameter.

   `student@rhel:~$` `sudo reboot`

0. **Troubleshoot in GRUB Menu**: If the system fails to boot, enter the GRUB menu by pressing `e` at the boot prompt to edit the boot parameters directly in GRUB.

0. **Remove the Invalid Parameter**: Locate the `invalid_param` entry, delete it, and press `Ctrl+X` to boot with the modified parameters.

   > **Note**: This will allow you to boot into the system temporarily, and you can correct the configuration in `/etc/default/grub` afterward.

   **Section 4: Using GRUB for System Recovery in Single-User Mode**

0. **Enter Single-User Mode**: In the GRUB menu, select your operating system and press `e` to edit the boot parameters. Locate the line starting with `linux` and add `single` or `rescue` to the end of this line.

0. **Boot into Single-User Mode**: Press `Ctrl+X` to boot with the modified parameters and enter single-user mode.

0. **Perform Recovery Tasks**: Once in single-user mode, perform the following recovery actions:
   - **Remount the Root Filesystem as Read/Write**: Run the command:

     `student@rhel:~#` `mount -o remount,rw /`

   - **Check and Repair Filesystems**: Run `fsck` to check filesystems for errors.

     `student@rhel:~#` `fsck -f /dev/mapper/rhel-root`

   > **Explanation**: Running `fsck` on critical filesystems in single-user mode ensures that no services interfere with file repairs.

0. **Reboot to Normal Mode**: Reboot the system to return to normal mode.

   `student@rhel:~#` `reboot`

   **Section 5: Reinstalling GRUB in Recovery Scenarios**

0. **Boot into Rescue Mode**: During boot, access the GRUB menu and add the keyword `rescue` to the kernel parameters as in Section 4. This will boot the system into rescue mode.

0. **Verify System Readiness**: Ensure that the system has mounted the root partition. You can confirm this by running:

   `student@rhel:~#` `lsblk`

0. **Reinstall GRUB**: Use the following command to reinstall GRUB on the primary disk:

   `student@rhel:~#` `grub2-install /dev/sda`

   > **Note**: Substitute `/dev/sda` with the correct boot disk if it differs on your system.

0. **Reboot the System**: Reboot the system normally to verify the bootloader reinstall.

   `student@rhel:~#` `reboot`

**Conclusion**

In this lab, you learned:
- The stages of the Linux boot process.
- How to modify GRUB boot parameters to control boot behavior.
- Recovery techniques using single-user mode.
- How to reinstall GRUB for system recovery.

With these skills, you’re now better prepared to troubleshoot boot issues and recover from bootloader errors.

**Extra Practice: Boot into Single-User Mode and Run a Recovery Command**

**Objective**:  
Boot into single-user mode and repair a corrupted file in `/etc/`.

1. **Boot into Single-User Mode**: Edit the GRUB entry to add `single` to the kernel parameters.

2. **Repair the File**: Identify the corrupted file and replace it with a backup.

<details>
<summary>Click here for a hint!</summary>

1. Use the `mv` command to rename the corrupted file and move a backup copy in its place.
2. Reboot the system to verify the repair.

</details>

<details>
<summary>Click here for the solution</summary>

0. Rename the corrupted file (replace `corrupted_file` with the filename):
    ```bash
    mv /etc/corrupted_file /etc/corrupted_file.bak
    ```

2. Restore from a backup:
    ```bash
    cp /etc/corrupted_file.bak /etc/corrupted_file
    ```

3. Reboot the system to verify:
    ```bash
    reboot
    ```

</details>