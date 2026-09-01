from flask import Flask
from prometheus_client import Counter
from prometheus_client import generate_latest

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
    return generate_latest()

if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000
    )