# Warmup Activity, hmmm... Podman Containers and Systemd Services, it is.

<img src="https://pbs.twimg.com/media/GK6zEO_bcAAYaVN.jpg" width="500">

#### Objective:
You will create and configure a container to run on a specific port, then set it up to persist as a `systemd` service.

---

### Part 1: Create and Run the Container

1. Create a container named **`pizzaparty`** from the image `registry.gitlab.com/alta3-instructor/tmnt`.
2. Expose the container’s internal port `5055` on **localhost port `2224`**.

**Verification**: You can test that the container is running by executing:
- `curl localhost:2224/tmnt`
- `curl localhost:2224/splinter`

<details>
<summary>Click here for Part 1 solution</summary>

```bash
# This is NOT a required step (the image will be pulled regardless) but here's the command just in case a RHCSA exam task requires it of you:
podman pull registry.gitlab.com/alta3-instructor/tmnt

# Create and run the container, exposing the correct ports
podman run --name pizzaparty -d -p 2224:5055 registry.gitlab.com/alta3-instructor/tmnt
```

</details>

---

### Part 2: Make the Container Persistent as a Systemd Service

1. Once the container is running, configure it to persist as a **systemd** service. It should be named `container-pizzaparty`.
2. This allows the container to automatically start with the system.

<details>
<summary>Click here for Part 2 solution</summary>

```bash
# Generate a systemd service file for the container
podman generate systemd --name pizzaparty --files --new

# Move the generated service file to the systemd directory
sudo mv container-pizzaparty.service /etc/systemd/system/

# Reload systemd to recognize the new service file
sudo systemctl daemon-reload

# Enable the service to start on boot
sudo systemctl enable container-pizzaparty

# Start the service
sudo systemctl start container-pizzaparty

# Confirm the service
sudo systemctl status container-pizzaparty
```

</details>
