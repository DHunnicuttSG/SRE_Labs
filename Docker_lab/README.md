# Docker SRE Lab

This lab runs the ticketing app, a separate MySQL-backed asset inventory app, and the monitoring stack with Docker Compose. It is independent of `AWS_TF_Lab` and does not provision a VM or other cloud infrastructure.

## Start

From this directory:

```sh
cp .env.example .env
docker compose up --build -d
docker compose ps
```

On PowerShell, copy the example with:

```powershell
Copy-Item .env.example .env
```

The apps wait for their databases to pass health checks. The first start can take a few minutes while images are downloaded and database volumes are initialized.

## Open the lab

- Ticketing app: http://localhost:5050
- MySQL asset inventory CRUD app: http://localhost:5051
- Grafana dashboard: http://localhost:3030 (credentials are in `.env`)
- Prometheus targets and alerts: http://localhost:9091/targets and http://localhost:9091/alerts
- Alertmanager: http://localhost:9094

These host ports are distinct from the AWS lab defaults, so both labs can run at once. Override them in `.env` if any are already occupied.

The inventory app lets learners create, list, edit, and delete assets with an owner, environment, and operational status. Its health endpoint checks its MySQL connection, and its metrics endpoint reports request counts and latency.

## Observability

Prometheus scrapes the ticketing and inventory apps every 15 seconds. Grafana provisions Prometheus and Loki data sources plus a service overview dashboard. Both apps write to standard output and to separate files in the `lab_logs` named volume; Grafana Alloy reads those files and ships them to Loki. Explore logs in Grafana with `{job="docker_lab"}`.

Prometheus includes alerts for an app scrape failure, ticket SLA breaches, and elevated inventory p95 latency. Alertmanager groups alerts for inspection in its UI. No email, chat, or webhook destination is configured by default.

## Useful commands

```sh
docker compose logs -f ticket-app inventory-app
docker compose down
```

`docker compose down` preserves database and monitoring data in named volumes. To remove all lab data and start fresh, run `docker compose down -v`.

The credentials in `.env.example` are for local training only. Change them before exposing the services on a network.