from flask import Flask, Response
from prometheus_client import Counter
from prometheus_client import generate_latest
from prometheus_client import CONTENT_TYPE_LATEST

app = Flask(__name__)

REQUESTS = Counter(
    "app_requests_total",
    "Total Requests"
)

@app.route("/")
def home():
    REQUESTS.inc()
    return {
        "service":"ticket-api",
        "status":"healthy"
    }

@app.route("/health")
def health():
    return {"status":"UP"}

@app.route("/metrics")
def metrics():
    return Response(
        generate_latest(),
        mimetype=CONTENT_TYPE_LATEST
    )


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000
    )