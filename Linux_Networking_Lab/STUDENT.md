# Student Exercise: Diagnose a Linux Network

## Goal

Practice inspecting interfaces and routes, checking name resolution and connectivity, and testing a listening service. The lab starts a local HTTP service at `127.0.0.1:8080`, so the graded checks work without external network access.

## 1. Inspect the host network

Create a directory for your collected command output:

```sh
cd ~/networking_lab
mkdir -p reports
```

Then:

- Use `ip -brief addr` to inspect interfaces and save the output to `reports/interfaces.txt`.
- Use `ip route` to inspect the routing table and save the output to `reports/routes.txt`.
- Use `ping -c 2 127.0.0.1` to test loopback connectivity and save the output to `reports/ping.txt`.
- Use `getent hosts localhost` to check local name resolution and save the output to `reports/dns.txt`.

Example pattern for saving output while still viewing it:

```sh
some-command | tee reports/output.txt
```

You can also try `dig example.com` to inspect a DNS response. This optional check depends on external network access and is not graded.

## 2. Find and test the local service

- Use `ss -tulpn` to locate the listening service on port `8080`; save the output to `reports/listeners.txt`.
- Use `nc -vz 127.0.0.1 8080` to test its TCP port; save both output streams to `reports/tcp-check.txt`.
- Use `curl -I http://127.0.0.1:8080` to inspect the HTTP response headers; save the output to `reports/http-headers.txt`.

Optional: use `traceroute -m 5 127.0.0.1` to inspect the local route. Results for remote destinations can vary by network and firewall.

## 3. Submit

Run the grader from any directory in the container:

```sh
bash /opt/linux-networking-lab/grade.sh
```

The grader checks the saved command output. It cannot prove which commands you typed, so be prepared to demonstrate your troubleshooting steps. Avoid changing interfaces or routes; this exercise only requires diagnostic commands.