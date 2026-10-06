import logging
import os
import time

import mysql.connector
from flask import Flask, Response, abort, g, jsonify, redirect, render_template, request, url_for
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Histogram, generate_latest

log_path = os.getenv("APP_LOG_PATH", "/tmp/inventory-app.log")
os.makedirs(os.path.dirname(log_path), exist_ok=True)
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s level=%(levelname)s service=inventory-app %(message)s",
    handlers=[logging.StreamHandler(), logging.FileHandler(log_path)],
    force=True,
)

app = Flask(__name__)
STATUSES = ("Healthy", "Maintenance", "Retired")

REQUEST_COUNT = Counter(
    "inventory_http_requests_total",
    "HTTP requests handled by the inventory app",
    ["method", "endpoint", "status"],
)
REQUEST_LATENCY = Histogram(
    "inventory_http_request_duration_seconds",
    "HTTP request duration for the inventory app",
    ["endpoint"],
)


def connect_database():
    return mysql.connector.connect(
        host=os.getenv("MYSQL_HOST", "localhost"),
        port=int(os.getenv("MYSQL_PORT", "3306")),
        database=os.getenv("MYSQL_DATABASE", "inventorydb"),
        user=os.getenv("MYSQL_USER", "inventoryuser"),
        password=os.getenv("MYSQL_PASSWORD", "inventorydevpass"),
        connection_timeout=5,
    )


def initialize_database():
    connection = connect_database()
    try:
        cursor = connection.cursor()
        cursor.execute(
            """
            CREATE TABLE IF NOT EXISTS assets (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(120) NOT NULL,
                owner VARCHAR(120) NOT NULL,
                environment VARCHAR(40) NOT NULL,
                status VARCHAR(24) NOT NULL,
                created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
            """
        )
        connection.commit()
        cursor.close()
    finally:
        connection.close()


def run_query(statement, values=(), *, fetch=None):
    connection = connect_database()
    try:
        cursor = connection.cursor(dictionary=fetch is not None)
        cursor.execute(statement, values)
        result = cursor.fetchall() if fetch == "all" else cursor.fetchone() if fetch == "one" else None
        connection.commit()
        cursor.close()
        return result
    finally:
        connection.close()


def form_values():
    values = (
        request.form.get("name", "").strip(),
        request.form.get("owner", "").strip(),
        request.form.get("environment", "").strip(),
        request.form.get("status", "").strip(),
    )
    if not all(values[:3]) or values[3] not in STATUSES:
        return None
    return values


@app.before_request
def start_request_timer():
    g.request_started = time.perf_counter()


@app.after_request
def record_request_metrics(response):
    endpoint = request.endpoint or "unknown"
    REQUEST_COUNT.labels(request.method, endpoint, str(response.status_code)).inc()
    REQUEST_LATENCY.labels(endpoint).observe(time.perf_counter() - g.request_started)
    app.logger.info(
        "request method=%s path=%s status=%s",
        request.method,
        request.path,
        response.status_code,
    )
    return response


@app.get("/")
def index():
    assets = run_query("SELECT * FROM assets ORDER BY id DESC", fetch="all")
    return render_template("assets.html", assets=assets)


@app.route("/assets/new", methods=["GET", "POST"])
def create_asset():
    if request.method == "POST":
        values = form_values()
        if values is None:
            return render_template(
                "asset_form.html", asset=None, statuses=STATUSES,
                error="Complete each field and choose a valid status.",
            ), 400
        run_query(
            "INSERT INTO assets (name, owner, environment, status) VALUES (%s, %s, %s, %s)",
            values,
        )
        return redirect(url_for("index"))
    return render_template("asset_form.html", asset=None, statuses=STATUSES, error=None)


@app.route("/assets/<int:asset_id>/edit", methods=["GET", "POST"])
def edit_asset(asset_id):
    asset = run_query("SELECT * FROM assets WHERE id = %s", (asset_id,), fetch="one")
    if asset is None:
        abort(404)
    if request.method == "POST":
        values = form_values()
        if values is None:
            return render_template(
                "asset_form.html", asset=asset, statuses=STATUSES,
                error="Complete each field and choose a valid status.",
            ), 400
        run_query(
            "UPDATE assets SET name = %s, owner = %s, environment = %s, status = %s WHERE id = %s",
            (*values, asset_id),
        )
        return redirect(url_for("index"))
    return render_template("asset_form.html", asset=asset, statuses=STATUSES, error=None)


@app.post("/assets/<int:asset_id>/delete")
def delete_asset(asset_id):
    run_query("DELETE FROM assets WHERE id = %s", (asset_id,))
    return redirect(url_for("index"))


@app.get("/health")
def health():
    run_query("SELECT 1", fetch="one")
    return jsonify(status="UP", database="UP")


@app.get("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)


if __name__ == "__main__":
    initialize_database()
    app.run(host="0.0.0.0", port=5001)