# Instructor Notes

## Learning objectives

Students practice `ip addr`, `ip route`, `ping`, `getent`, `ss`, `nc`, and `curl` to diagnose a local network path and service. The container starts a Python HTTP server bound only to loopback on port 8080; no external connectivity is needed for graded work.

## Answer key

From the student's shell:

```sh
cd ~/networking_lab
mkdir -p reports
ip -brief addr | tee reports/interfaces.txt
ip route | tee reports/routes.txt
ping -c 2 127.0.0.1 | tee reports/ping.txt
getent hosts localhost | tee reports/dns.txt
ss -tulpn | tee reports/listeners.txt
nc -vz 127.0.0.1 8080 2>&1 | tee reports/tcp-check.txt
curl -I http://127.0.0.1:8080 | tee reports/http-headers.txt
bash /opt/linux-networking-lab/grade.sh
```

Optional exploration includes `dig example.com` and `traceroute -m 5 127.0.0.1`. These rely on behavior outside the graded local-service checks.

## Grading

The grader awards 100 points for captured output showing a loopback interface, a default route, a loopback ping reply, local name resolution, the listening HTTP port, a successful TCP connection, and an HTTP 200 response. The output files demonstrate the results, not that students personally entered each command. Observe the task or request a short explanation if command-use evidence is required.

The grader and initialization script are visible teaching materials, not a tamper-resistant assessment system.